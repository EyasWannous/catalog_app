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
  final String hivePrice;

  @HiveField(4)
  final dynamic _hiveRating; // Changed to dynamic to handle both int and double

  @HiveField(5)
  final int hiveCategoryId;

  // Getter to safely convert rating to double
  double get hiveRating {
    if (_hiveRating is double) return _hiveRating;
    if (_hiveRating is int) return _hiveRating.toDouble();
    return 0.0;
  }

  const ProductModel({
    required this.hiveId,
    required this.hiveName,
    required this.hiveDescription,
    required this.hivePrice,
    required double hiveRating,
    required this.hiveCategoryId,
  }) : _hiveRating = hiveRating,
       super(
         id: hiveId,
         name: hiveName,
         description: hiveDescription,
         price: hivePrice,
         rating: hiveRating,
         categoryId: hiveCategoryId,
       );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      hiveId:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      hiveName: json['name']?.toString() ?? '',
      hiveDescription: json['description']?.toString() ?? '',
      hivePrice: json['price']?.toString() ?? '0',
      hiveRating:
          json['rating'] is double
              ? json['rating']
              : double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      hiveCategoryId:
          json['categoryId'] is int
              ? json['categoryId']
              : int.tryParse(json['categoryId']?.toString() ?? '1') ?? 1,
    );
  }

  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      hiveId: entity.id,
      hiveName: entity.name,
      hiveDescription: entity.description,
      hivePrice: entity.price,
      hiveRating: entity.rating,
      hiveCategoryId: entity.categoryId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': hiveId,
    'name': hiveName,
    'description': hiveDescription,
    'price': hivePrice,
    'rating': hiveRating,
    'categoryId': hiveCategoryId,
  };
}
