import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:catalog_app/features/products/domain/usecase/get_single_product_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetSingleProductUseCase getSingleProductUseCase;

  ProductCubit(this.getSingleProductUseCase) : super(ProductInitial());

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
}
