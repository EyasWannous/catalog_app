import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:catalog_app/features/products/domain/entities/products_response.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductsResponse>> getProducts(
    String categoryId, {
    int? pageNumber,
    int? pageSize,
  });
  Future<Either<Failure, Product>> getProduct(int id);
  Future<Either<Failure, Product>> postProduct(
    String name,
    String description,
    String categoryId,
  );
  Future<Either<Failure, Product>> updateProduct(
    int id,
    String name,
    String description,
    String categoryId,
  );
  Future<Either<Failure, void>> deleteProduct(int id);
}
