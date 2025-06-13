import 'package:hive/hive.dart';
import 'package:catalog_app/features/products/domain/entities/product_entity.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel extends ProductEntity {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String price;

  @HiveField(4)
  final int rating;

  @HiveField(5)
  final int categoryId;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.categoryId,
  }) : super(
    id: id,
    name: name,
    description: description,
    price: price,
    rating: rating,
    categoryId: categoryId,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      rating: json['rating'],
      categoryId: json['categoryId'],
    );
  }
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id!,
      name: entity.name!,
      description: entity.description!,
      price: entity.price!,
      rating: entity.rating!,
      categoryId: entity.categoryId!,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'rating': rating,
    'categoryId': categoryId,
  };
}
