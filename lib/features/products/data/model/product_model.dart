import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel extends Product {
  @HiveField(0)
  final int hiveId;

  @HiveField(1)
  final String hiveName;

  @HiveField(2)
  final String hiveDescription;

  @HiveField(3)
  final int hiveCategoryId;

  const ProductModel({
    required this.hiveId,
    required this.hiveName,
    required this.hiveDescription,
    required this.hiveCategoryId,
  }) : super(
    id: hiveId,
    name: hiveName,
    description: hiveDescription,
    categoryId: hiveCategoryId,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      hiveId: json['id'],
      hiveName: json['name'],
      hiveDescription: json['description'],
      hiveCategoryId: json['categoryId'],
    );
  }
  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      hiveId: entity.id,
      hiveName: entity.name,
      hiveDescription: entity.description,
      hiveCategoryId: entity.categoryId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': hiveId,
    'name': hiveName,
    'description': hiveDescription,
    'categoryId': hiveCategoryId,
  };
}
