import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/categroy/domain/entities/category.dart';
import 'package:catalog_app/features/categroy/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class CreateCategoryUseCase {
  final CategoryRepository repository;

  CreateCategoryUseCase(this.repository);

  Future<Either<Failure, Category>> call(String name, String description) async {
    return await repository.postCategory(name, description);
  }
}
