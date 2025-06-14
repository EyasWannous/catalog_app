import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:catalog_app/features/products/domain/entities/attachment.dart';
import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:catalog_app/features/products/domain/usecase/create_product_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/create_product_with_images_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/create_attachment_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/delete_attachment_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/delete_product_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/get_products_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/update_product_use_case.dart';
import 'package:meta/meta.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  final CreateProductUseCase createProductUseCase; // Legacy - kept for backward compatibility
  final CreateProductWithImagesUseCase createProductWithImagesUseCase;
  final CreateAttachmentUseCase createAttachmentUseCase;
  final DeleteAttachmentUseCase deleteAttachmentUseCase;
  final DeleteAttachmentsUseCase deleteAttachmentsUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  int _currentPage = 1;
  bool _isFetching = false;
  final int _pageSize = 20;
  bool _hasMore = true;
  final List<Product> _products = [];
  String? _currentCategoryId;

  ProductsCubit(
    this.getProductsUseCase,
    this.createProductUseCase,
    this.createProductWithImagesUseCase,
    this.createAttachmentUseCase,
    this.deleteAttachmentUseCase,
    this.deleteAttachmentsUseCase,
    this.updateProductUseCase,
    this.deleteProductUseCase,
  ) : super(ProductsInitial());

  Future<void> getProducts(
    String categoryId, {
    bool isInitialLoad = false,
  }) async {
    if (_isFetching) {
      return;
    }

    if (!_hasMore && !isInitialLoad) {
      return;
    }

    _isFetching = true;

    if (isInitialLoad || _currentCategoryId != categoryId) {
      _currentPage = 1;
      _products.clear();
      _currentCategoryId = categoryId;
      emit(ProductsLoading());
    } else {
      emit(
        ProductsLoaded(
          products: List.from(_products),
          isLoadingMore: true,
          hasMore: _hasMore,
        ),
      );
    }

    try {
      final result = await getProductsUseCase(
        categoryId,
        pageNumber: _currentPage,
        pageSize: _pageSize,
      );
      result.fold(
        (failure) => emit(ProductsError(message: "Failed to load: $failure")),
        (response) {
          final newProducts = response.products;

          _products.addAll(newProducts);
          _hasMore = newProducts.length == _pageSize;

          if (_hasMore) _currentPage++;

          emit(
            ProductsLoaded(
              products: List.from(_products),
              isLoadingMore: false,
              hasMore: _hasMore,
            ),
          );
        },
      );
    } catch (e) {
      emit(ProductsError(message: "Exception: $e"));
    } finally {
      _isFetching = false;
    }
  }

  // New method for creating products with images
  Future<void> createProductWithImages(
    String name,
    String description,
    String price,
    String categoryId,
    List<File> images,
  ) async {
    emit(ProductFormSubmitting());
    try {
      final result = await createProductWithImagesUseCase(
        name,
        description,
        price,
        categoryId,
        images,
      );
      result.fold(
        (failure) => emit(ProductFormError(message: failure.toString())),
        (product) => emit(ProductFormSuccess(product: product)),
      );
    } catch (e) {
      emit(ProductFormError(message: e.toString()));
    }
  }

  // Legacy method - kept for backward compatibility
  @Deprecated('Use createProductWithImages instead')
  Future<void> createProduct(
    String name,
    String description,
    String price,
    String categoryId,
    List<Attachment> attachemts,
  ) async {
    emit(ProductFormSubmitting());
    try {
      final result = await createProductUseCase(
        name,
        description,
        price,
        categoryId,
        attachemts,
      );
      result.fold(
        (failure) => emit(ProductFormError(message: failure.toString())),
        (product) => emit(ProductFormSuccess(product: product)),
      );
    } catch (e) {
      emit(ProductFormError(message: e.toString()));
    }
  }

  Future<void> updateProduct(
    int id,
    String name,
    String description,
    String price,
    String categoryId,
  ) async {
    emit(ProductFormSubmitting());
    final result = await updateProductUseCase(
      id,
      name,
      description,
      price,
      categoryId,
    );
    result.fold(
      (failure) => emit(ProductFormError(message: failure.toString())),
      (product) => emit(ProductFormSuccess(product: product)),
    );
  }

  Future<void> deleteProduct(int id) async {
    emit(ProductDeleting());
    final result = await deleteProductUseCase(id);
    result.fold(
      (failure) => emit(ProductDeleteError(message: failure.toString())),
      (_) => emit(ProductDeleted()),
    );
  }

  Future<void> updateProductWithImages({
    required int id,
    required String name,
    required String description,
    required String price,
    required String categoryId,
    required List<File> images,
  }) async {
    emit(ProductFormSubmitting());

    try {
      // 1. Update product data only (PUT /products)
      final updateResult = await updateProductUseCase(
        id,
        name,
        description,
        price,
        categoryId,
      );

      updateResult.fold(
        (failure) => emit(ProductFormError(message: failure.toString())),
        (product) async {
          // 2. Add new images as attachments if any (POST /attachments)
          if (images.isNotEmpty) {
            try {
              for (final image in images) {
                final attachmentResult = await createAttachmentUseCase(id, image);
                attachmentResult.fold(
                  (failure) => emit(ProductFormError(message: 'Failed to add image: ${failure.toString()}')),
                  (_) {}, // Continue with next image
                );
              }
            } catch (e) {
              emit(ProductFormError(message: 'Failed to add images: ${e.toString()}'));
              return;
            }
          }

          emit(ProductFormSuccess(product: product));
        },
      );
    } catch (e) {
      emit(ProductFormError(message: e.toString()));
    }
  }

  // Attachment management methods
  Future<void> addAttachmentToProduct(int productId, File imageFile) async {
    emit(ProductFormSubmitting());
    try {
      final result = await createAttachmentUseCase(productId, imageFile);
      result.fold(
        (failure) => emit(ProductFormError(message: failure.toString())),
        (attachment) => emit(AttachmentAdded(attachment: attachment)),
      );
    } catch (e) {
      emit(ProductFormError(message: e.toString()));
    }
  }

  Future<void> removeAttachment(int attachmentId) async {
    emit(ProductFormSubmitting());
    try {
      final result = await deleteAttachmentUseCase(attachmentId);
      result.fold(
        (failure) => emit(ProductFormError(message: failure.toString())),
        (_) => emit(AttachmentDeleted(attachmentId: attachmentId)),
      );
    } catch (e) {
      emit(ProductFormError(message: e.toString()));
    }
  }

  Future<void> removeMultipleAttachments(List<int> attachmentIds) async {
    emit(ProductFormSubmitting());
    try {
      final result = await deleteAttachmentsUseCase(attachmentIds);
      result.fold(
        (failure) => emit(ProductFormError(message: failure.toString())),
        (_) => emit(AttachmentsDeleted(attachmentIds: attachmentIds)),
      );
    } catch (e) {
      emit(ProductFormError(message: e.toString()));
    }
  }
}
