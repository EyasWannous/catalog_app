import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategories _getCategories;

  int _currentPage = 1;
  bool _isFetching = false;
  final int _pageSize = 20;
  bool _hasMore = true;
  final List<Category> _categories = [];

  CategoriesCubit(this._getCategories) : super(CategoriesInitial());

  Future<void> getCategories({bool isInitialLoad = false}) async {
    if (_isFetching) {
      return;
    }

    if (!_hasMore && !isInitialLoad) {
      return;
    }

    _isFetching = true;

    if (isInitialLoad) {
      _currentPage = 1;
      _categories.clear();
      emit(CategoriesLoading());
    } else {
      emit(
        CategoriesLoaded(
          categories: List.from(_categories),
          isLoadingMore: true,
          hasMore: _hasMore,
        ),
      );
    }

    try {
      final response = await _getCategories(
        pageNumber: _currentPage,
        pageSize: _pageSize,
      );

      if (response.isSuccessful) {
        final newCategories = response.categories;

        _categories.addAll(newCategories);
        _hasMore = newCategories.length == _pageSize;



        if (_hasMore) _currentPage++;

        emit(
          CategoriesLoaded(
            categories: List.from(_categories),
            isLoadingMore: false,
            hasMore: _hasMore,
          ),
        );
      } else {
        emit(CategoriesError("Failed to load: ${response.responseTime}"));
      }
    } catch (e) {
      emit(CategoriesError("Exception: $e"));
    } finally {
      _isFetching = false;
    }
  }
}
