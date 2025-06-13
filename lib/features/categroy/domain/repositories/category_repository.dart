import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/categroy/domain/entities/categories_response.dart';
import 'package:catalog_app/features/categroy/domain/entities/category.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryRepository {
  Future<Either<Failure,CategoriesResponse>> getCategories({int? pageNumber, int? pageSize});
  Future<Either<Failure, Category>> getCategory(int id);
  Future<Either<Failure, Category>> postCategory(
    String name,
    String description,
  );
  Future<Either<Failure, Category>> updateCategory(
    int id,
    String name,
    String description,
  );
  Future<Either<Failure, void>> deleteCategory(int id);
}
