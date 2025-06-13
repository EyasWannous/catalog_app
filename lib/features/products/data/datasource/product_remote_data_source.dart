import 'package:catalog_app/core/error/exception.dart';
import 'package:catalog_app/core/network/api_service.dart';
import 'package:catalog_app/features/products/data/model/product_model.dart';
import 'package:catalog_app/features/products/data/model/product_response_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductResponseModel> getProducts(
    String categoryId, {
    int? pageNumber,
    int? pageSize,
  });
  Future<ProductModel> getProduct(int id);

  Future<ProductResponseModel> searchProducts(
    String categoryId,
    String searchQuery, {
    int? pageNumber,
    int? pageSize,
  });

  Future<ProductModel> postProduct(
    String name,
    String description,
    int categoryId,
  );
  Future<ProductModel> updateProduct(
    int id,
    String name,
    String description,
    int categoryId,
  );
  Future<void> deleteProduct(int id);
}

class ProductRemoteDataSourceImpl extends ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl(this.apiService);

  @override
  Future<ProductResponseModel> getProducts(
    String categoryId, {
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      final response = await apiService.get(
        '/Categories/$categoryId/products',
        queryParameters: {
          'pageNumber': pageNumber ?? 1,
          'pageSize': pageSize ?? 10,
        },
      );

      print(response.toString());
      return ProductResponseModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    try {
      final response = await apiService.get('/products/$id');

      print(response.toString());
      return ProductModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> postProduct(
    String name,
    String description,
    int categoryId,
  ) async {
    var body = ProductModel(
      hiveId: 0,
      hiveName: name,
      hiveDescription: description,
      hiveCategoryId: categoryId,
    );

    try {
      final response = await apiService.post('/products', data: body.toJson());

      print(response.toString());
      return ProductModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> updateProduct(
    int id,
    String name,
    String description,
    int categoryId,
  ) async {
    var body = ProductModel(
      hiveId: id,
      hiveName: name,
      hiveDescription: description,
      hiveCategoryId: categoryId,
    );

    try {
      final response = await apiService.put(
        '/products/$id',
        data: body.toJson(),
      );

      print(response.toString());
      return ProductModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      final response = await apiService.delete('/products/$id');

      print(response.toString());
      return;
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<ProductResponseModel> searchProducts(
    String categoryId,
    String searchQuery, {
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      final response = await apiService.get(
        '/Categories/$categoryId/products',
        queryParameters: {
          'pageNumber': pageNumber ?? 1,
          'pageSize': pageSize ?? 10,
          'searchQuery': searchQuery,
        },
      );

      print(response.toString());
      return ProductResponseModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }
}
