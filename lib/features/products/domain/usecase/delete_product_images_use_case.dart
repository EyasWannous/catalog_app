import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/products/domain/repository/product_repository.dart';
import 'package:dartz/dartz.dart';

@Deprecated('Use DeleteAttachmentsUseCase instead')
class DeleteProductImagesUseCase {
  final ProductRepository repository;

  DeleteProductImagesUseCase(this.repository);

  Future<Either<Failure, bool>> call(
    List<int> attachmentIds,
  ) async {
    return await repository.deleteProductImage(attachmentIds);
  }
}