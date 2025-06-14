import 'dart:io';
import 'package:catalog_app/features/products/domain/entities/attachment.dart';
import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:catalog_app/features/products/domain/usecase/create_attachment_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/delete_attachment_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/delete_product_images_use_case.dart';
import 'package:catalog_app/features/products/domain/usecase/get_single_product_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetSingleProductUseCase getSingleProductUseCase;
  final DeleteProductImagesUseCase deleteProductImageUseCase; // Legacy - kept for backward compatibility
  final CreateAttachmentUseCase createAttachmentUseCase;
  final DeleteAttachmentUseCase deleteAttachmentUseCase;

  ProductCubit(
    this.getSingleProductUseCase,
    this.deleteProductImageUseCase,
    this.createAttachmentUseCase,
    this.deleteAttachmentUseCase,
  ) : super(ProductInitial());

  // Placeholder images for demo - in real app, use product.attachments
  final offers = [
    'https://picsum.photos/400/200?random=1',
    'https://picsum.photos/400/200?random=2',
    'https://picsum.photos/400/200?random=3',
  ];

  int currentIndex = 0;

  Future<void> getProduct(int productId) async {
    emit(ProductLoading());
    try {
      final result = await getSingleProductUseCase(productId);
      result.fold(
        (failure) => emit(ProductError("Failed to load product: $failure")),
        (product) => emit(ProductLoaded(product)),
      );
    } catch (e) {
      emit(ProductError("Exception: $e"));
    }
  }

  void setImageIndex(int index) {
    if (state is ProductLoaded) {
      final loaded = state as ProductLoaded;
      emit(ProductLoaded(loaded.product));
    }
  }

  // New method for deleting specific attachment by ID
  Future<void> deleteAttachment(int attachmentId) async {
    emit(ProductImageDeleting());

    try {
      final result = await deleteAttachmentUseCase(attachmentId);

      result.fold(
        (failure) {
          emit(ProductError('Failed to delete attachment: ${failure.toString()}'));
          // Re-emit loaded state to restore UI
          _reloadCurrentProduct();
        },
        (_) {
          emit(ProductAttachmentDeleted(attachmentId: attachmentId));
          // Reload product to get updated attachments
          _reloadCurrentProduct();
        },
      );
    } catch (e) {
      emit(ProductError('Error deleting attachment: ${e.toString()}'));
      _reloadCurrentProduct();
    }
  }

  // New method for adding attachment to product
  Future<void> addAttachment(int productId, File imageFile) async {
    emit(ProductAttachmentAdding());

    try {
      final result = await createAttachmentUseCase(productId, imageFile);

      result.fold(
        (failure) {
          emit(ProductError('Failed to add attachment: ${failure.toString()}'));
          _reloadCurrentProduct();
        },
        (attachment) {
          emit(ProductAttachmentAdded(attachment: attachment));
          // Reload product to get updated attachments
          _reloadCurrentProduct();
        },
      );
    } catch (e) {
      emit(ProductError('Error adding attachment: ${e.toString()}'));
      _reloadCurrentProduct();
    }
  }

  // Helper method to reload current product
  void _reloadCurrentProduct() {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      getProduct(currentState.product.id);
    }
  }

  // Legacy method - kept for backward compatibility
  @Deprecated('Use deleteAttachment instead')
  Future<void> deleteProductImage(int productId, int imageIndex) async {
    // For backward compatibility, we'll try to map imageIndex to attachment
    if (state is ProductLoaded) {
      final product = (state as ProductLoaded).product;
      if (imageIndex >= 0 && imageIndex < product.attachments.length) {
        final attachmentId = product.attachments[imageIndex].id;
        await deleteAttachment(attachmentId);
      }
    }
  }
}
