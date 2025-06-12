import 'package:catalog_app/features/categroy/data/models/pagination_model.dart';
import 'package:catalog_app/features/products/data/model/product_model.dart';
import 'package:catalog_app/features/products/domain/entities/product_response_entity.dart';

class ProductResponseModel extends ProductResponseEntity {
  ProductResponseModel({
    required super.products,
    required super.pagination,
    required super.isSuccessful,
    required super.responseTime,
    required super.error,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      products:
          (json['data'] as List).map((e) => ProductModel.fromJson(e)).toList(),
      pagination: PaginationModel.fromJson(json),
      isSuccessful: json['isSuccessful'],
      responseTime: json['responseTime'],
      error: json['error'] ?? '',
    );
  }
}
