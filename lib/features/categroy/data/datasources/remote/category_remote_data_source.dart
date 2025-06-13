import 'package:catalog_app/core/error/exception.dart';
import 'package:catalog_app/core/network/api_service.dart';
import 'package:catalog_app/features/categroy/data/models/categories_response_model.dart';
import 'package:catalog_app/features/categroy/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<CategoriesResponseModel> getCategories({
    int? pageNumber,
    int? pageSize,
  });
  Future<CategoryModel> getCategory(int id);
  Future<CategoryModel> postCategory(String name, String description);
  Future<CategoryModel> updateCategory(int id, String name, String description);
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
      print(response.toString());
      return CategoriesResponseModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      final response = await apiService.delete('/Categories/$id');

      print(response.toString());
      return;
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<CategoryModel> getCategory(int id) async {
    try {
      final response = await apiService.get('/Categories/$id');

      print(response.toString());
      return CategoryModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<CategoryModel> postCategory(String name, String description) async {
    var body = CategoryModel(
      hiveId: 0,
      hiveName: name,
      hiveDescription: description,
    );

    try {
      final response = await apiService.post(
        '/Categories',
        data: body.toJson(),
      );

      print(response.toString());
      return CategoryModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<CategoryModel> updateCategory(
    int id,
    String name,
    String description,
  ) async {
    var body = CategoryModel(
      hiveId: id,
      hiveName: name,
      hiveDescription: description,
    );

    try {
      final response = await apiService.put(
        '/Categories/$id',
        data: body.toJson(),
      );

      print(response.toString());
      return CategoryModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }
}
