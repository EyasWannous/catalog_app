import 'package:catalog_app/core/error/exception.dart';
import 'package:catalog_app/core/network/api_service.dart';
import 'package:catalog_app/core/utils/logger.dart';
import 'package:catalog_app/features/products/data/model/product_model.dart';
import 'package:catalog_app/features/products/data/model/product_response_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductResponseModel> getProducts(
    String categoryId, {
    int? pageNumber,
    int? pageSize,
  });
  Future<ProductModel> getProduct(int id);
  Future<ProductModel> postProduct(
    String name,
    String description,
    String categoryId,
  );
  Future<ProductModel> updateProduct(
    int id,
    String name,
    String description,
    String categoryId,
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
      AppLogger.info('Get products response: ${response.toString()}');
      return ProductResponseModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('Error getting products', e);
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    try {
      final response = await apiService.get('/products/$id');

      AppLogger.info('Get product response: ${response.toString()}');

      // Extract the 'data' field from the API response
      final productData = response.data['data'];
      if (productData == null) {
        AppLogger.error('Product data is null in API response', null);
        throw ServerException();
      }

      AppLogger.info('Parsing product data: ${productData.toString()}');
      return ProductModel.fromJson(productData);
    } catch (e) {
      AppLogger.error('Error getting product', e);
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> postProduct(
    String name,
    String description,
    String categoryId,
  ) async {
    var body = ProductModel(
      hiveId: 0,
      hiveName: name,
      hiveDescription: description,
      hivePrice: "0",
      hiveRating: 0.0,
      hiveCategoryId: int.parse(categoryId),
    );

    try {
      final response = await apiService.post('/products', data: body.toJson());

      AppLogger.info('Post product response: ${response.toString()}');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('Error posting product', e);
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> updateProduct(
    int id,
    String name,
    String description,
    String categoryId,
  ) async {
    var body = ProductModel(
      hiveId: id,
      hiveName: name,
      hiveDescription: description,
      hivePrice: "0",
      hiveRating: 0.0,
      hiveCategoryId: int.parse(categoryId),
    );

    try {
      final response = await apiService.put(
        '/products/$id',
        data: body.toJson(),
      );

      AppLogger.info('Update product response: ${response.toString()}');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('Error updating product', e);
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      final response = await apiService.delete('/products/$id');

      AppLogger.info('Delete product response: ${response.toString()}');
      return;
    } catch (e) {
      AppLogger.error('Error deleting product', e);
      throw ServerException();
    }
  }
}
