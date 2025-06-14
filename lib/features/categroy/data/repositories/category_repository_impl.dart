import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/core/network/network_info.dart';
import 'package:catalog_app/features/categroy/data/datasources/remote/category_remote_data_source.dart';
import 'package:catalog_app/features/categroy/data/models/category_model.dart';
import 'package:catalog_app/features/categroy/data/models/categories_response_model.dart';
import 'package:catalog_app/features/categroy/domain/entities/category.dart';
import 'package:catalog_app/features/categroy/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

import '../datasources/local/category_local_data_source.dart';
import '../models/pagination_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CategoriesResponseModel>> getCategories({
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteResponse = await remoteDataSource.getCategories(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        // Cache only the category list
        await localDataSource.cacheCategories(
          remoteResponse.categories.cast<CategoryModel>(),
        );
        return Right(remoteResponse);
      } else {
        final cachedCategories = await localDataSource.getCachedCategories();
        // Build a minimal response from cache
        return Right(
          CategoriesResponseModel(
            categories: cachedCategories,
            pagination: PaginationModel(
              page: 1,
              totalCount: 1,
              resultCount: 1,
              resultsPerPage: 1,
            ), // You can define an empty state
            success: true,
            responseTime: DateTime.now().toIso8601String(),
          ),
        );
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      if (await networkInfo.isConnected) {
        var response = await remoteDataSource.deleteCategory(id);

        return Right(response);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> getCategory(int id) async {
    try {
      if (await networkInfo.isConnected) {
        var response = await remoteDataSource.getCategory(id);

        return Right(response);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> postCategory(
    String name,
    String description,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        var response = await remoteDataSource.postCategory(name, description);

        return Right(response);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(
    int id,
    String name,
    String description,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        var response = await remoteDataSource.updateCategory(id, name, description);

        return Right(response);
      }
      return Left(OfflineFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
