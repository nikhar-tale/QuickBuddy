import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:quick_buy/core/graphql/graphql_service.dart';
import 'package:quick_buy/features/cart/data/models/cart_item_model.dart';

class CartRepository {
  // GraphQL query for fetching the cart.
  static const String getCartQuery = r'''
    query MyQuery {
  cart(
    id: "gid://shopify/Cart/Z2NwLWFzaWEtc291dGhlYXN0MTowMUpIWkpCVjA4R1hSOVNZOFE1UkgzUVNBSA?key=f4b24fdce768e1532dced3be6cd3e336"
  ) {
    attributes {
      key
      value
    }
    checkoutUrl
    cost {
      checkoutChargeAmount {
        amount
        currencyCode
      }
      subtotalAmount {
        amount
        currencyCode
      }
      subtotalAmountEstimated
      totalAmount {
        amount
        currencyCode
      }
      totalAmountEstimated
      totalDutyAmount {
        amount
        currencyCode
      }
      totalDutyAmountEstimated
      totalTaxAmount {
        amount
        currencyCode
      }
      totalTaxAmountEstimated
    }
    discountAllocations {
      discountedAmount {
        amount
        currencyCode
      }
    }
    createdAt
    discountCodes {
      applicable
      code
    }
    id
    lines(first: 10) {
      edges {
        node {
          attributes {
            key
            value
          }
          cost {
            amountPerQuantity {
              amount
              currencyCode
            }
            compareAtAmountPerQuantity {
              amount
              currencyCode
            }
            subtotalAmount {
              amount
              currencyCode
            }
            totalAmount {
              amount
              currencyCode
            }
          }
          discountAllocations {
            discountedAmount {
              amount
              currencyCode
            }
          }
          id
          merchandise {
            ... on ProductVariant {
              id
              image {
                src
              }
              price {
                amount
                currencyCode
              }
              title
              sku
              selectedOptions {
                name
                value
              }
              unitPrice {
                amount
                currencyCode
              }
            }
          }
          quantity
          ... on CartLine {
            id
            quantity
            merchandise {
              ... on ProductVariant {
                id
                image {
                  src
                }
                sku
                title
                product {
                  title
                }
                selectedOptions {
                  name
                  value
                }
              }
            }
          }
          ... on ComponentizableCartLine {
            id
            merchandise {
              ... on ProductVariant {
                id
                product {
                  title
                }
              }
            }
          }
        }
      }
    }
    totalQuantity
  }
}
  ''';

  /// Executes the cart query and returns a list of [CartItem]s.
  Future<List<CartItem>> fetchCartItems() async {
    final client = await GraphQLService.getClient();

    final result = await client.query(
      QueryOptions(
        document: gql(getCartQuery),
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    // Parse the 'cart' data from the response.
    final cartData = result.data?['cart'];
    if (cartData == null) {
      return [];
    }

    final linesData = cartData['lines']?['edges'] as List<dynamic>? ?? [];
    List<CartItem> items = [];

    for (var edge in linesData) {
      final node = edge['node'];
      if (node == null) continue;

      // Parse quantity
      final quantity = node['quantity'] as int? ?? 0;

      // Parse the total price from cost.totalAmount.amount
      double totalPrice = 0.0;
      final totalAmountData = node['cost']?['totalAmount'];
      if (totalAmountData != null && totalAmountData['amount'] != null) {
        totalPrice =
            double.tryParse(totalAmountData['amount'].toString()) ?? 0.0;
      }

      // Parse the product title.
      // We check for both the variant title and its product's title.
      String title = '';
      if (node['merchandise'] != null) {
        final merchandise = node['merchandise'];
        // Prefer the product title if available.
        if (merchandise['product']?['title'] != null) {
          title = merchandise['product']['title'];
        } else if (merchandise['title'] != null) {
          title = merchandise['title'];
        }
      }

      items.add(
        CartItem(
          title: title,
          quantity: quantity,
          totalPrice: totalPrice,
        ),
      );
    }

    return items;
  }
}
