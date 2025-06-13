import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/products/domain/entities/products_response.dart';
import 'package:catalog_app/features/products/domain/repository/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetProductsUseCase {
  final ProductRepository productRepository;

  GetProductsUseCase(this.productRepository);

  /// If [searchQuery] is provided, searchProducts is called.
  Future<Either<Failure, ProductsResponse>> call(
    String categoryId, {
    required int pageNumber,
    required int pageSize,
    String? searchQuery,
  }) async {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      return await productRepository.searchProducts(
        categoryId,
        searchQuery,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
    } else {
      return await productRepository.getProducts(
        categoryId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
    }
  }
}
