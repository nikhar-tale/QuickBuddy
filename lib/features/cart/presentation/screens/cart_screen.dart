import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_buy/core/firebase/style_bloc.dart';
import 'package:quick_buy/features/cart/presentation/blocs/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  // Utility: Convert hex string to Color.
  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    // Listen to dynamic style updates.
    return BlocBuilder<StyleBloc, StyleState>(
      builder: (context, styleState) {
        Color cardColor = Colors.white;
        Color textColor = Colors.black;
        double borderRadius = 8.0;
        String fontFamily = 'Roboto';
        double fontSize = 16.0;

        if (styleState is StyleLoaded) {
          cardColor = _hexToColor(styleState.cardColor);
          textColor = _hexToColor(styleState.textColor);
          borderRadius = styleState.borderRadius;
          fontFamily = styleState.fontFamily;
          fontSize = styleState.fontSize;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'My Cart',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: fontSize,
                color: textColor,
              ),
            ),
            backgroundColor: cardColor,
          ),
          body: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CartError) {
                return Center(child: Text(state.message));
              } else if (state is CartLoaded) {
                final cartItems = state.cartItems;
                double total = 0.0;
                for (var item in cartItems) {
                  total += item.totalPrice;
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return ListTile(
                            title: Text(
                              item.title,
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: fontSize,
                                color: textColor,
                              ),
                            ),
                            subtitle: Text(
                              'Quantity: ${item.quantity}',
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: fontSize,
                                color: textColor,
                              ),
                            ),
                            trailing: Text(
                              "\$${item.totalPrice}",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSize,
                              color: textColor,
                            ),
                          ),
                          Text(
                            "\$$total",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
