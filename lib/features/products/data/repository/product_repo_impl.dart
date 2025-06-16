import 'dart:io';
import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/core/network/network_info.dart';
import 'package:catalog_app/features/categroy/domain/entities/pagination.dart';
import 'package:catalog_app/features/products/data/datasource/product_local_data_source.dart';
import 'package:catalog_app/features/products/data/datasource/product_remote_data_source.dart';
import 'package:catalog_app/features/products/data/model/product_model.dart';
import 'package:catalog_app/features/products/data/model/product_response_model.dart';
import 'package:catalog_app/features/products/domain/entities/attachment.dart';
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

    final productModels =
        response.products.map((e) => ProductModel.fromEntity(e)).toList();

    // Cache products by category
    await productLocalDataSource.cacheProductsByCategory(
      categoryId,
      productModels,
    );

    // Also cache individual products for faster detail access
    for (final productModel in productModels) {
      await productLocalDataSource.cacheProduct(productModel);
    }

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
      // First, try to get from cache if it's valid
      final cachedProduct = await productLocalDataSource.getCachedProduct(id);
      if (cachedProduct != null) {
        // Return cached product immediately for better performance
        return Right(cachedProduct);
      }

      // If not in cache or expired, fetch from network only if connected
      if (await networkInfo.isConnected) {
        final response = await productRemoteDataSource.getProduct(id);

        // Cache the fetched product for future use
        await productLocalDataSource.cacheProduct(
          ProductModel.fromEntity(response),
        );

        return Right(response);
      } else {
        // If offline and no valid cache, return offline failure
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(
    int id,
    String name,
    String description,
    String price,
    String categoryId,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await productRemoteDataSource.updateProduct(
          id,
          name,
          description,
          price,
          categoryId,
        );

        // Remove the specific product from cache and invalidate category cache
        await productLocalDataSource.removeCachedProduct(id);
        await productLocalDataSource.invalidateCache();

        // Cache the updated product
        await productLocalDataSource.cacheProduct(
          ProductModel.fromEntity(response),
        );

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
        final response = await productRemoteDataSource.deleteProduct(id);

        // Remove the specific product from cache and invalidate category cache
        await productLocalDataSource.removeCachedProduct(id);
        await productLocalDataSource.invalidateCache();

        return Right(response);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  // New methods for proper backend integration
  @override
  Future<Either<Failure, Product>> createProductWithImages(
    String name,
    String description,
    String price,
    String categoryId,
    List<File> images,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await productRemoteDataSource.createProductWithImages(
          name,
          description,
          price,
          categoryId,
          images,
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
  Future<Either<Failure, Attachment>> createAttachment(
    int productId,
    File imageFile,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await productRemoteDataSource.createAttachment(
          productId,
          imageFile,
        );

        // Invalidate cache to refresh product data
        await productLocalDataSource.removeCachedProduct(productId);
        await productLocalDataSource.invalidateCache();

        return Right(response);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAttachment(int attachmentId) async {
    try {
      if (await networkInfo.isConnected) {
        await productRemoteDataSource.deleteAttachment(attachmentId);

        // Invalidate cache to refresh product data
        await productLocalDataSource.invalidateCache();

        return const Right(null);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAttachments(
    List<int> attachmentIds,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        // Delete each attachment individually
        for (final attachmentId in attachmentIds) {
          await productRemoteDataSource.deleteAttachment(attachmentId);
        }

        // Invalidate cache to refresh product data
        await productLocalDataSource.invalidateCache();

        return const Right(null);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
