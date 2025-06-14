import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/products/domain/entities/attachment.dart';
import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:catalog_app/features/products/domain/repository/product_repository.dart';
import 'package:dartz/dartz.dart';

@Deprecated('Use CreateProductWithImagesUseCase instead')
class CreateProductUseCase {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  Future<Either<Failure, Product>> call(
    String name,
    String description,
    String price,
    String categoryId,
    List<Attachment> attachments,
  ) async {
    return await repository.postProduct(
      name,
      description,
      price,
      categoryId,
      attachments,
    );
  }
}
