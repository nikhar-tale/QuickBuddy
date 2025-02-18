import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0) // Each model must have a unique typeId
class Product extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? imageUrl;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final bool isInStock;

  const Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.isInStock,
  });

  // Example fromJson method (modify as needed)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String?,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      isInStock: json['isInStock'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [id, title, imageUrl, price, isInStock];
}
