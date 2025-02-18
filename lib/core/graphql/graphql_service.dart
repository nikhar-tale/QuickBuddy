import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static GraphQLClient? _client;

  /// Initialize the GraphQL client with your endpoint and headers.
  /// For Shopify, you'd use your Storefront API endpoint & token.
  static Future<GraphQLClient> getClient() async {
    if (_client != null) return _client!;

    final HttpLink httpLink = HttpLink(
      'https://vikas-test-bean.myshopify.com//api/2024-10/graphql.json',
      defaultHeaders: {
        'X-Shopify-Storefront-Access-Token': '01f9402f3dab4f9cbb7908cf2c48a812',
        'Content-Type': 'application/json',
      },
    );

    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    return _client!;
  }
}
