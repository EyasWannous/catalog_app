import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/core/network/network_info.dart';
import 'package:catalog_app/features/categroy/domain/entities/pagination.dart';
import 'package:catalog_app/features/products/data/datasource/product_local_data_source.dart';
import 'package:catalog_app/features/products/data/datasource/product_remote_data_source.dart';
import 'package:catalog_app/features/products/data/model/product_model.dart';
import 'package:catalog_app/features/products/data/model/product_response_model.dart';
import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:catalog_app/features/products/domain/entities/products_response.dart';
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
  Future<Either<Failure, ProductsResponse>> getProducts(
    String categoryId, {
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        return await _getAndCacheProducts(
          categoryId,
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
      } else {
        return await _getCachedProducts(categoryId);
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, ProductsResponse>> _getAndCacheProducts(
    String categoryId, {
    int? pageNumber,
    int? pageSize,
  }) async {
    final response = await productRemoteDataSource.getProducts(
      categoryId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    await productLocalDataSource.cacheProductsByCategory(
      categoryId,
      response.products.map((e) => ProductModel.fromEntity(e)).toList(),
    );

    return Right(response);
  }

  Future<Either<Failure, ProductsResponse>> _getCachedProducts(
    String categoryId,
  ) async {
    try {
      final cachedProducts = (await productLocalDataSource
          .getCachedProductsByCategory(categoryId));
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

  @override
  Future<Either<Failure, Product>> getProduct(int id) async {
    try {
      if (await networkInfo.isConnected) {
        var response = await productRemoteDataSource.getProduct(id);

        return Right(response);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> postProduct(
    String name,
    String description,
    int categoryId,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        var response = await productRemoteDataSource.postProduct(
          name,
          description,
          categoryId,
        );

        await productLocalDataSource.invalidateCache();

        return Right(response);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(
    int id,
    String name,
    String description,
    int categoryId,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        var response = await productRemoteDataSource.updateProduct(
          id,
          name,
          description,
          categoryId,
        );

        await productLocalDataSource.invalidateCache();

        return Right(response);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      if (await networkInfo.isConnected) {
        var response = await productRemoteDataSource.deleteProduct(id);

        await productLocalDataSource.invalidateCache();

        return Right(response);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ProductsResponse>> searchProducts(
    String categoryId,
    String searchQuery, {
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      final response = await productRemoteDataSource.searchProducts(
        categoryId,
        searchQuery,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      return Right(response);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
