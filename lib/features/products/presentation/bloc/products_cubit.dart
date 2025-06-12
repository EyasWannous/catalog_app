import 'package:bloc/bloc.dart';
import 'package:catalog_app/features/products/data/model/product_model.dart';
import 'package:catalog_app/features/products/domain/entities/product_response_entity.dart';
import 'package:catalog_app/features/products/domain/usecase/get_product_use_case.dart';
import 'package:meta/meta.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsCubit(this.getProductsUseCase) : super(ProductsInitial());

  Future<void> getProducts(String categoryId) async {
    emit(ProductsLoading());
    final result = await getProductsUseCase(categoryId);
    result.fold(
      (failure) => emit(ProductsError(message: failure.toString())),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }
}
