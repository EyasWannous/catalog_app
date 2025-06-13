import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

part 'product_state.dart';


class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  final offers = [
    'https://picsum.photos/400/200?random=1',
    'https://picsum.photos/400/200?random=2',
    'https://picsum.photos/400/200?random=3',
  ];

  int currentIndex = 0;

  Future<void> getProduct(int productId) async {
    emit(ProductLoading());
    try {
      // Mock: Replace with your real repo call
      final product = Product(
        id: productId,
        name: "Product #$productId",
        description: "This is a detailed description for product #$productId.",
        categoryId: 1,
      );
      emit(ProductLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void setImageIndex(int index) {
    if (state is ProductLoaded) {
      final loaded = state as ProductLoaded;
      emit(ProductLoaded(loaded.product));
    }
  }
}