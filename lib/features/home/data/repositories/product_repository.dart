import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:quick_buy/core/graphql/graphql_service.dart';
import 'package:quick_buy/core/hive/hive_service.dart';
import 'package:quick_buy/features/home/data/models/product_model.dart';

class ProductRepository {
  // Your GraphQL query (unchanged)
  static const String fetchProductsQuery = r'''
  query($id : ID!, $cursor : String, $limit : Int, $sortKey : ProductCollectionSortKeys, $reverse: Boolean, $filters: [ProductFilter!], $identifiers:[HasMetafieldsIdentifier!]!) @inContext(language:BS){
    collection(id: $id) {
      title
      metafields(
        identifiers: $identifiers
      ) {
        key
        value
        reference {
          ... on MediaImage {
            id
            image {
              src
            }
          }
        }
      }
      products(first: $limit, sortKey: $sortKey, after: $cursor, reverse: $reverse, filters: $filters) {
        edges {
          node {
            id
            title
            images(first: 1) {
              edges {
                node {
                  altText
                  src
                }
              }
            }
            priceRange {
              maxVariantPrice {
                amount
                currencyCode
              }
              minVariantPrice {
                amount
                currencyCode
              }
            }
            productType
            availableForSale
            collections(first: 10) {
              edges {
                node {
                  id
                  title
                  handle
                }
              }
            }
            metafields(
              identifiers: [
                {key: "rating", namespace: "reviews"},
                {key: "rating_count", namespace: "reviews"}
              ]
            ) {
              key
              value
            }
            description
            variants(first: 250) {
              edges {
                node {
                  id
                  storeAvailability(first: 250, near: {latitude: 1.5, longitude: 1.5}) {
                    nodes {
                      available
                      location {
                        address {
                          address1
                          address2
                          city
                          country
                          countryCode
                          formatted
                          latitude
                          longitude
                          phone
                          province
                          provinceCode
                          zip
                        }
                        id
                        name
                      }
                      pickUpTime
                      quantityAvailable
                    }
                  }
                }
              }
            }
          }
          cursor
        }
        filters {
          id
          label
          type
          values {
            count
            id
            input
            label
            swatch {
              color
              image {
                image {
                  src
                  id
                }
              }
            }
          }
        }
        pageInfo {
          endCursor
          hasNextPage
          startCursor
          hasPreviousPage
        }
      }
    }
  }
  ''';

  /// Public method to fetch products.
  /// This method returns cached data immediately (if available)
  /// and also triggers a background fetch to update the cache.
  Future<List<Product>> fetchProducts({
    required String id,
    required int limit,
    List<dynamic> filters = const [],
    required List<Map<String, String>> identifiers,
    required String sortKey,
    required bool reverse,
    String? cursor,
  }) async {
    // Retrieve cached data from Hive.
    final List<Product>? cachedProducts =
        await HiveService.getProducts('productsBox');

    // Trigger a background update.
    _updateCacheInBackground(
      id: id,
      limit: limit,
      filters: filters,
      identifiers: identifiers,
      sortKey: sortKey,
      reverse: reverse,
      cursor: cursor,
    );

    // If cached products are available and non-empty, return them immediately.
    if (cachedProducts != null && cachedProducts.isNotEmpty) {
      return cachedProducts;
    } else {
      // Otherwise, wait for fresh data from the server.
      return await _fetchAndCacheFromServer(
        id: id,
        limit: limit,
        filters: filters,
        identifiers: identifiers,
        sortKey: sortKey,
        reverse: reverse,
        cursor: cursor,
      );
    }
  }

  /// Internal method: fetch products from the server and update the cache.
  Future<List<Product>> _fetchAndCacheFromServer({
    required String id,
    required int limit,
    List<dynamic> filters = const [],
    required List<Map<String, String>> identifiers,
    required String sortKey,
    required bool reverse,
    String? cursor,
  }) async {
    final client = await GraphQLService.getClient();

    final result = await client.query(
      QueryOptions(
        document: gql(fetchProductsQuery),
        variables: {
          "id": id,
          "filters": filters,
          "limit": limit,
          "identifiers": identifiers,
          "sortKey": sortKey,
          "reverse": reverse,
          "cursor": cursor,
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final collectionData = result.data?['collection'];
    if (collectionData == null) {
      return [];
    }

    final productsData = collectionData['products'];
    if (productsData == null) {
      return [];
    }

    final edges = productsData['edges'] as List<dynamic>;
    List<Product> products = [];

    for (var edge in edges) {
      final node = edge['node'];
      if (node == null) continue;

      // Basic fields
      final productId = node['id'] as String;
      final productTitle = node['title'] as String;

      // Parse image
      final imagesEdges = node['images']?['edges'] as List<dynamic>? ?? [];
      String? imageSrc;
      if (imagesEdges.isNotEmpty) {
        imageSrc = imagesEdges.first['node']['src'] as String?;
      }

      // Parse price using minVariantPrice for demonstration.
      final priceRange = node['priceRange'];
      double parsedPrice = 0.0;
      if (priceRange != null) {
        final minVariantPrice = priceRange['minVariantPrice']?['amount'];
        if (minVariantPrice != null) {
          parsedPrice = double.tryParse(minVariantPrice.toString()) ?? 0.0;
        }
      }

      // Stock status
      final availableForSale = node['availableForSale'] as bool? ?? false;

      products.add(
        Product(
          id: productId,
          title: productTitle,
          imageUrl: imageSrc,
          price: parsedPrice,
          isInStock: availableForSale,
        ),
      );
    }

    // Store the fresh data in Hive for future fast loads.
    await HiveService.storeProducts('productsBox', products);

    return products;
  }

  /// Triggers a background fetch to update the cache without blocking the UI.
  void _updateCacheInBackground({
    required String id,
    required int limit,
    List<dynamic> filters = const [],
    required List<Map<String, String>> identifiers,
    required String sortKey,
    required bool reverse,
    String? cursor,
  }) {
    _fetchAndCacheFromServer(
      id: id,
      limit: limit,
      filters: filters,
      identifiers: identifiers,
      sortKey: sortKey,
      reverse: reverse,
      cursor: cursor,
    ).then((freshProducts) {
      // Optionally, notify listeners or update your BLoC with the fresh data.
      // For example, you might emit an event in your HomeBloc.
      // print("Background cache update complete. Fetched ${freshProducts.length} products.");
    }).catchError((error) {
      // Handle any errors during the background fetch if needed.
      // print("Error during background cache update: $error");
    });
  }
}
