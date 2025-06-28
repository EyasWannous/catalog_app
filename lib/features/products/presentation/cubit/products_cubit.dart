import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:catalog_app/core/utils/logger.dart';
import 'package:catalog_app/features/products/domain/entities/attachment.dart';
import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:catalog_app/features/products/domain/usecase/create_attachment_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/create_product_with_images_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/delete_attachment_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/delete_product_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/get_products_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/get_products_with_search_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/update_product_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/update_product_with_attachments_use_case.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductsWithSearchUseCase getProductsWithSearchUseCase;
  final CreateProductWithImagesUseCase createProductWithImagesUseCase;
  final CreateAttachmentUseCase createAttachmentUseCase;
  final DeleteAttachmentUseCase deleteAttachmentUseCase;
  final DeleteAttachmentsUseCase deleteAttachmentsUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final UpdateProductWithAttachmentsUseCase updateProductWithAttachmentsUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  int _currentPage = 1;
  bool _isFetching = false;
  final int _pageSize = 20;
  bool _hasMore = true;
  final List<Product> _products = [];
  String? _currentCategoryId;
  String? _currentSearchQuery;

  ProductsCubit(
    this.getProductsUseCase,
    this.getProductsWithSearchUseCase,
    this.createProductWithImagesUseCase,
    this.createAttachmentUseCase,
    this.deleteAttachmentUseCase,
    this.deleteAttachmentsUseCase,
    this.updateProductUseCase,
    this.updateProductWithAttachmentsUseCase,
    this.deleteProductUseCase,
  ) : super(ProductsInitial());

  Future<void> getProducts(
    String categoryId, {
    bool isInitialLoad = false,
    String? searchQuery,
  }) async {
    // ✅ FIX: Validate categoryId
    AppLogger.info(
      '🛍️ ProductsCubit.getProducts called with categoryId: "$categoryId"',
    );
    if (categoryId.isEmpty) {
      AppLogger.error('❌ Invalid category ID: categoryId cannot be empty');
      emit(
        ProductsError(
          message: "Invalid category ID: categoryId cannot be empty",
        ),
      );
      return;
    }

    if (_isFetching) {
      return;
    }

    if (!_hasMore && !isInitialLoad) {
      return;
    }

    _isFetching = true;

    // Reset pagination if category or search query changed
    if (isInitialLoad ||
        _currentCategoryId != categoryId ||
        _currentSearchQuery != searchQuery) {
      _currentPage = 1;
      _products.clear();
      _currentCategoryId = categoryId;
      _currentSearchQuery = searchQuery;
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
      // Use search use case if search query is provided, otherwise use regular use case
      final result =
          searchQuery != null && searchQuery.isNotEmpty
              ? await getProductsWithSearchUseCase(
                categoryId,
                pageNumber: _currentPage,
                pageSize: _pageSize,
                searchQuery: searchQuery,
              )
              : await getProductsUseCase(
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

  // New method for searching products
  Future<void> searchProducts(
    String categoryId,
    String searchQuery, {
    bool isInitialLoad = true,
  }) async {
    await getProducts(
      categoryId,
      isInitialLoad: isInitialLoad,
      searchQuery: searchQuery,
    );
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

  Future<void> updateProduct(
    int id,
    String name,
    String description,
    String price,
    String categoryId,
    String syrianPoundPrice,
  ) async {
    emit(ProductFormSubmitting());
    final result = await updateProductUseCase(
      id,
      name,
      description,
      price,
      categoryId,
      syrianPoundPrice,
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
    String? name,
    String? description,
    String? price,
    int? categoryId,
    List<File>? images,
  }) async {
    emit(ProductFormSubmitting());

    try {
      final result = await updateProductWithAttachmentsUseCase(
        id,
        name: name,
        description: description,
        price: price,
        categoryId: categoryId,
        images: images,
      );

      result.fold(
        (failure) => emit(ProductFormError(message: failure.toString())),
        (product) => emit(ProductFormSuccess(product: product)),
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
