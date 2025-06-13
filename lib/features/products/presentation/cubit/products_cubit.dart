import 'package:bloc/bloc.dart';
import 'package:catalog_app/features/categroy/domain/entities/pagination.dart';
import 'package:catalog_app/features/products/domain/entities/products_response.dart';
import 'package:catalog_app/features/products/domain/usecase/get_product_use_case.dart';
import 'package:catalog_app/features/products/domain/entities/product.dart';
import 'package:meta/meta.dart';

part 'products_state.dart';
class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  int _currentPage = 1;
  bool _isFetching = false;
  final int _pageSize = 20;
  bool _hasMore = true;
  final List<Product> _products = [];
  String? _currentSearchQuery;

  ProductsCubit(this.getProductsUseCase) : super(ProductsInitial());

  Future<void> getProducts(
    String categoryId, {
    bool isInitialLoad = false,
    String? searchQuery,
  }) async {
    if (_isFetching) return;

    // If it's a new search query => treat it as initial load
    if (_currentSearchQuery != searchQuery) {
      isInitialLoad = true;
    }

    if (!_hasMore && !isInitialLoad) return;

    _isFetching = true;

    if (isInitialLoad) {
      _currentPage = 1;
      _products.clear();
      _hasMore = true;
      _currentSearchQuery = searchQuery;
      emit(ProductsLoading());
    } else {
      emit(
        ProductsLoaded(
          response: ProductsResponse(
            products: List.from(_products),
            pagination: Pagination(
              page: _currentPage,
              totalCount: _products.length, // approximate
              resultCount: _products.length,
              resultsPerPage: _pageSize,
            ),
            isSuccessful: true,
            responseTime: '',
            error: '',
          ),
          isLoadingMore: true,
        ),
      );
    }

    final result = await getProductsUseCase(
      categoryId,
      pageNumber: _currentPage,
      pageSize: _pageSize,
      searchQuery: searchQuery,
    );

    result.fold(
      (failure) {
        emit(ProductsError(message: failure.toString()));
      },
      (response) {
        final newProducts = response.products;
        _products.addAll(newProducts);

        _hasMore = response.pagination.hasNextPage;

        if (_hasMore) _currentPage++;

        emit(
          ProductsLoaded(
            response: ProductsResponse(
              products: List.from(_products),
              pagination: response.pagination,
              isSuccessful: response.isSuccessful,
              responseTime: response.responseTime,
              error: response.error,
            ),
            isLoadingMore: false,
          ),
        );
      },
    );

    _isFetching = false;
  }
}
