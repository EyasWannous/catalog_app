import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final String price;
  final double rating;
  final int categoryId;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [id, name, description, price, rating, categoryId];

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, rating: $rating, categoryId: $categoryId)';
  }
}
