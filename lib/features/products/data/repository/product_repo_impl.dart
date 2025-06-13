import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/core/network/network_info.dart';
import 'package:catalog_app/features/categroy/domain/entities/pagination.dart';
import 'package:catalog_app/features/products/data/datasource/product_local_data_source.dart';
import 'package:catalog_app/features/products/data/datasource/product_remote_data_source.dart';
import 'package:catalog_app/features/products/data/model/product_model.dart';
import 'package:catalog_app/features/products/data/model/product_response_model.dart';
import 'package:catalog_app/features/products/domain/entities/product_entity.dart';
import 'package:catalog_app/features/products/domain/entities/product_response_entity.dart';
import 'package:catalog_app/features/products/domain/repository/product_repository.dart';
import 'package:dartz/dartz.dart';

class ProductRepoImpl extends ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;
  final ProductLocalDataSource productLocalDataSource;
  final NetworkInfo networkInfo;

  ProductRepoImpl({
    required this.productRemoteDataSource,
    required this.productLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductResponseEntity>> getProducts(String categoryId) async {
    try {
      if (await networkInfo.isConnected) {
        return await _getAndCacheProducts(categoryId);
      } else {
        return await _getCachedProducts(categoryId);
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, ProductResponseEntity>> _getAndCacheProducts(String categoryId) async {
    final response = await productRemoteDataSource.getProducts(categoryId);
    await productLocalDataSource.cacheProductsByCategory(
      categoryId,
      response.products.map((e) => ProductModel.fromEntity(e)).toList(),
    );
    return Right(response);
  }

  Future<Either<Failure, ProductResponseEntity>> _getCachedProducts(String categoryId) async {
    try {
      final cachedProducts = (await productLocalDataSource.getCachedProductsByCategory(categoryId))
          ;
      return Right(
        ProductResponseModel(
          products: cachedProducts,
          isSuccessful: true,
          responseTime: DateTime.now().toIso8601String(),
          pagination: Pagination(
            page: 1,
            totalCount: 1,
            resultCount: 1,
            resultsPerPage: 1,
          ),
          error: '',
        ),
      );
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
