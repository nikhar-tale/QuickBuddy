import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_buy/core/firebase/style_bloc.dart';
import 'package:quick_buy/features/home/data/models/product_model.dart';
import 'package:quick_buy/features/home/presentation/blocs/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Utility to convert hex string to a Color.
  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the UI in a BlocBuilder to get dynamic style settings.
    return BlocBuilder<StyleBloc, StyleState>(
      builder: (context, styleState) {
        // Set default style values.
        Color cardColor = Colors.white;
        Color textColor = Colors.black;
        double borderRadius = 8.0;
        String fontFamily = 'Roboto';
        double fontSize = 16.0;

        // If styles are loaded, override defaults.
        if (styleState is StyleLoaded) {
          cardColor = _hexToColor(styleState.cardColor);
          textColor = _hexToColor(styleState.textColor);
          borderRadius = styleState.borderRadius;
          fontFamily = styleState.fontFamily;
          fontSize = styleState.fontSize;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "The Ordinary",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            backgroundColor: cardColor,
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is HomeError) {
                        return Center(child: Text(state.message));
                      } else if (state is HomeLoaded) {
                        final products = state.products;
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              // Horizontal Slider
                              // SizedBox(
                              //   height: 200,
                              //   child: ListView.builder(
                              //     scrollDirection: Axis.horizontal,
                              //     itemCount: products.length,
                              //     itemBuilder: (context, index) {
                              //       final product = products[index];
                              //       return _ProductCard(
                              //         product: product,
                              //         cardColor: cardColor,
                              //         textColor: textColor,
                              //         borderRadius: borderRadius,
                              //         fontFamily: fontFamily,
                              //         fontSize: fontSize,
                              //       );
                              //     },
                              //   ),
                              // ),
                              // Grid View
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(8.0),
                                itemCount: products.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      0.50, // Adjust for exact height/width
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return _ProductCard(
                                    product: product,
                                    cardColor: cardColor,
                                    textColor: textColor,
                                    borderRadius: borderRadius,
                                    fontFamily: fontFamily,
                                    fontSize: fontSize,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final Color cardColor;
  final Color textColor;
  final double borderRadius;
  final String fontFamily;
  final double fontSize;

  const _ProductCard({
    Key? key,
    required this.product,
    required this.cardColor,
    required this.textColor,
    required this.borderRadius,
    required this.fontFamily,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Card-like styling
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.imageUrl == null
                    ? Image.asset('assets/images/placeholder.png')
                    : Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/placeholder.png');
                        },
                      ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                product.title,
                style: TextStyle(
                  color: textColor,
                  fontFamily: fontFamily,
                  fontSize: fontSize,
                ),
              ),
            ),
            Text(
              "\$${product.price}",
              style: TextStyle(
                color: textColor,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            const SizedBox(height: 4),
            product.isInStock
                ? ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(AddToCartEvent(product));
                      Fluttertoast.showToast(msg: 'Added to Cart');
                    },
                    child: const Text('Add to Cart'),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Out of Stock',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontFamily: fontFamily,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
