import 'dart:io';

import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/categroy/domain/entities/categories_response.dart';
import 'package:catalog_app/features/categroy/domain/entities/category.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryRepository {
  Future<Either<Failure,CategoriesResponse>> getCategories({int? pageNumber, int? pageSize});

  // ✅ NEW: Get categories filtered by parentId for hierarchical navigation
  Future<Either<Failure,CategoriesResponse>> getCategoriesByParent({
    int? parentId,
    int? pageNumber,
    int? pageSize
  });

  Future<Either<Failure, Category>> getCategory(int id);
  Future<Either<Failure, Category>> postCategory(
    String name,
    String description,
    File image, {
    int? parentId, // ✅ NEW: Support parentId when creating categories
  });
  Future<Either<Failure, void>> updateCategory(
    int id,
    String name,
    String description,
    File image, {
    int? parentId, // ✅ NEW: Support parentId when updating categories
  });
  Future<Either<Failure, void>> deleteCategory(int id);
}
