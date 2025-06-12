import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/products/data/model/product_model.dart';
import 'package:catalog_app/features/products/domain/entities/product_entity.dart';
import 'package:catalog_app/features/products/domain/entities/product_response_entity.dart';
import 'package:catalog_app/features/products/domain/repository/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetProductsUseCase {
  final ProductRepository productRepository;

  GetProductsUseCase(this.productRepository);

  Future<Either<Failure, ProductResponseEntity>> call(String categoryId) async {
    return await productRepository.getProducts(categoryId);
  }
}