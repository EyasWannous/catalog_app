import 'package:bloc/bloc.dart';
import 'package:catalog_app/features/products/domain/usecase/delete_product_use_case.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/products_response.dart';
import '../../domain/usecase/get_products_use_case.dart';
import '../../domain/usecase/create_product_use_case.dart';
import '../../domain/usecase/update_product_use_case.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductsCubit(
    this.getProductsUseCase,
    this.createProductUseCase,
    this.updateProductUseCase,
    this.deleteProductUseCase,
  ) : super(ProductsInitial());

  Future<void> getProducts(String categoryId) async {
    emit(ProductsLoading());
    final result = await getProductsUseCase(categoryId);
    result.fold(
      (failure) => emit(ProductsError(message: failure.toString())),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }

  Future<void> createProduct(
    String name,
    String description,
    int categoryId,
  ) async {
    emit(ProductFormSubmitting());
    final result = await createProductUseCase(name, description, categoryId);
    result.fold(
      (failure) => emit(ProductFormError(message: failure.toString())),
      (product) => emit(ProductFormSuccess(product: product)),
    );
  }

  Future<void> updateProduct(
    int id,
    String name,
    String description,
    int categoryId,
  ) async {
    emit(ProductFormSubmitting());
    final result = await updateProductUseCase(
      id,
      name,
      description,
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
}
