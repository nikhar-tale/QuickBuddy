import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String title;
  final int quantity;
  final double totalPrice;

  const CartItem({
    required this.title,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [title, quantity, totalPrice];
}
