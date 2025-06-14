import 'dart:io';

import 'package:catalog_app/core/error/exception.dart';
import 'package:catalog_app/core/network/api_service.dart';
import 'package:catalog_app/core/utils/logger.dart';
import 'package:catalog_app/features/categroy/data/models/categories_response_model.dart';
import 'package:catalog_app/features/categroy/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<CategoriesResponseModel> getCategories({
    int? pageNumber,
    int? pageSize,
  });
  Future<CategoryModel> getCategory(int id);
  Future<CategoryModel> postCategory(
    String name,
    String description,
    File image,
  );
  Future<void> updateCategory(
    int id,
    String name,
    String description,
    File image,
  );
  Future<void> deleteCategory(int id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiService apiService;

  CategoryRemoteDataSourceImpl(this.apiService);
  @override
  Future<CategoriesResponseModel> getCategories({
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      final response = await apiService.get(
        '/Categories',
        queryParameters: {
          'pageNumber': pageNumber ?? 1,
          'pageSize': pageSize ?? 10,
        },
      );
      AppLogger.info(response.toString());
      return CategoriesResponseModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      final response = await apiService.delete('/Categories/$id');

      AppLogger.info(response.toString());
      return;
    } catch (e) {
      AppLogger.error(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<CategoryModel> getCategory(int id) async {
    try {
      final response = await apiService.get('/Categories/$id');

      AppLogger.info(response.toString());
      return CategoryModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<CategoryModel> postCategory(
    String name,
    String description,
    File image,
  ) async {
    try {
      final response = await apiService.uploadFile(
        '/Categories',
        image.path,
        data: {'Id': 0, 'Name': name, 'Description': description},
      );

      AppLogger.info(response.toString());
      return CategoryModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<void> updateCategory(
    int id,
    String name,
    String description,
    File image,
  ) async {
    try {
      final response = await apiService.updateUploadedFile(
        '/Categories',
        image.path,
        data: {'Id': id, 'Name': name, 'Description': description},
      );

      AppLogger.info(response.toString());
      return;
    } catch (e) {
      AppLogger.error(e.toString());
      throw ServerException();
    }
  }
}
