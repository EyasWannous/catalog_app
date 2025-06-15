import 'package:catalog_app/features/products/domain/entities/attachment.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final String price;
  final int categoryId;
  final List<Attachment> attachments;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.attachments,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    categoryId,
    attachments,
  ];

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, categoryId: $categoryId, attachments: ${attachments.map((x) => x.toString())})';
  }
}
