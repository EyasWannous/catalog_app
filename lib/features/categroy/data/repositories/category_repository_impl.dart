import 'package:catalog_app/core/network/network_info.dart';
import 'package:catalog_app/features/categroy/data/datasources/category_data_source.dart';
import 'package:catalog_app/features/categroy/data/models/category_model.dart';
import 'package:catalog_app/features/categroy/data/models/categories_response_model.dart';
import 'package:catalog_app/features/categroy/domain/repositories/category_repository.dart';

import '../datasources/local/category_local_data_source.dart';
import '../models/pagination_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<CategoriesResponseModel> getCategories({int? pageNumber, int? pageSize}) async {
    if (await networkInfo.isConnected) {
      final remoteResponse = await remoteDataSource.getCategories(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      // Cache only the category list
      await localDataSource.cacheCategories(remoteResponse.categories.cast<CategoryModel>());
      return remoteResponse;
    } else {
      final cachedCategories = await localDataSource.getCachedCategories();
      // Build a minimal response from cache
      return CategoriesResponseModel(
        categories: cachedCategories,
        pagination: PaginationModel(page: 1, totalCount: 1, resultCount: 1, resultsPerPage: 1), // You can define an empty state
        success: true,
        responseTime: DateTime.now().toIso8601String(),
      );
    }
  }
}
