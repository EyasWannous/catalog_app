import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/categroy/domain/entities/category.dart';
import 'package:catalog_app/features/categroy/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<Either<Failure, Category>> call(int id, String name, String description) async {
    return await repository.updateCategory(id, name, description);
  }
}