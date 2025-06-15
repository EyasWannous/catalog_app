import 'dart:io';

import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/categroy/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<Either<Failure, void>> call(int id, String name, String description, File image) async {
    return await repository.updateCategory(id, name, description, image);
  }
}