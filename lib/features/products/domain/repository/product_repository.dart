import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/products/data/model/product_model.dart';
import 'package:catalog_app/features/products/domain/entities/product_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductResponseEntity>> getProducts(String categoryId);
}