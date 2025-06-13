import 'package:catalog_app/core/error/exception.dart';
import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/core/network/api_service.dart';
import 'package:catalog_app/features/products/data/model/product_model.dart';
import 'package:catalog_app/features/products/data/model/product_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRemoteDataSource {
  Future<ProductResponseModel> getProducts(String categoryId);
}

class ProductRemoteDataSourceImpl extends ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl(this.apiService);

  @override
  Future<ProductResponseModel> getProducts(String categoryId) async {
    try {
      final response = await apiService.get('/Categories/$categoryId/products');
      print(response);
      return ProductResponseModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());

      throw ServerException();
    }
  }
}
