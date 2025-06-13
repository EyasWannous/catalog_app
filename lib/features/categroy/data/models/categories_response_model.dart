import 'package:catalog_app/features/categroy/data/models/category_model.dart';
import 'package:catalog_app/features/categroy/data/models/pagination_model.dart';
import 'package:catalog_app/features/categroy/domain/entities/categories_response.dart';

class CategoriesResponseModel extends CategoriesResponse {
  const CategoriesResponseModel({
    required List<CategoryModel> categories,
    required PaginationModel pagination,
    required bool success,
    required String responseTime,
  }) : super(
          categories: categories,
          pagination: pagination,
          isSuccessful: success,
          responseTime: responseTime,
        );

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesResponseModel(
      categories: (json['data'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json),
      success: json['isSuccessful'],
      responseTime: json['responseTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((e) => (e as CategoryModel).toJson()).toList(),
      'pagination': (pagination as PaginationModel).toJson(),
      'success': isSuccessful,
      'responseTime': responseTime,
    };
  }
}