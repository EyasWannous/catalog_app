import 'dart:io';
import 'package:catalog_app/core/error/failure.dart';
import 'package:catalog_app/features/products/domain/entities/attachment.dart';
import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:catalog_app/features/products/domain/entities/products_response.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  // Product operations
  Future<Either<Failure, ProductsResponse>> getProducts(
    String categoryId, {
    int? pageNumber,
    int? pageSize,
  });
  Future<Either<Failure, Product>> getProduct(int id);

  // Create product with images (POST /products with files)
  Future<Either<Failure, Product>> createProductWithImages(
    String name,
    String description,
    String price,
    String categoryId,
    List<File> images,
  );

  // Update product data only (PUT /products without images)
  Future<Either<Failure, Product>> updateProduct(
    int id,
    String name,
    String description,
    String price,
    String categoryId,
  );

  Future<Either<Failure, void>> deleteProduct(int id);

  // Attachment operations
  // Create attachment for existing product (POST /attachments)
  Future<Either<Failure, Attachment>> createAttachment(
    int productId,
    File imageFile,
  );

  // Delete specific attachment (DELETE /attachments/{id})
  Future<Either<Failure, void>> deleteAttachment(int attachmentId);

  // Delete multiple attachments
  Future<Either<Failure, void>> deleteAttachments(List<int> attachmentIds);
}
