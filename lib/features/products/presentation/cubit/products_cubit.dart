import 'package:bloc/bloc.dart';
import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:catalog_app/features/products/domain/usecase/get_product_use_case.dart';
import 'package:meta/meta.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  int _currentPage = 1;
  bool _isFetching = false;
  final int _pageSize = 20;
  bool _hasMore = true;
  final List<Product> _products = [];
  String? _currentCategoryId;

  ProductsCubit(this.getProductsUseCase) : super(ProductsInitial());

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
}
