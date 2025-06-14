import 'dart:io';

import 'package:catalog_app/features/categroy/domain/usecases/delete_category_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/create_category_use_case.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/update_category_use_case.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase _getCategories;
  final CreateCategoryUseCase _createCategory;
  final UpdateCategoryUseCase _updateCategory;
  final DeleteCategoryUseCase _deleteCategory;

  int _currentPage = 1;
  bool _isFetching = false;
  final int _pageSize = 20;
  bool _hasMore = true;
  final List<Category> _categories = [];

  CategoriesCubit(
    this._getCategories,
    this._createCategory,
    this._updateCategory,
    this._deleteCategory,
  ) : super(CategoriesInitial());

  List<Category> get currentCategories => List.from(_categories);

  Future<void> getCategories({bool isInitialLoad = false}) async {
    if (_isFetching) return;
    if (!_hasMore && !isInitialLoad) return;

    _isFetching = true;

    if (isInitialLoad) {
      _currentPage = 1;
      _categories.clear();
      emit(CategoriesLoading());
    } else {
      emit(
        CategoriesLoaded(
          categories: currentCategories,
          isLoadingMore: true,
          hasMore: _hasMore,
        ),
      );
    }

    try {
      final result = await _getCategories(
        pageNumber: _currentPage,
        pageSize: _pageSize,
      );

      result.fold(
        (failure) => emit(CategoriesError("Failed to load: $failure")),
        (response) {
          final newCategories = response.categories;
          _categories.addAll(newCategories);
          _hasMore = newCategories.length == _pageSize;
          if (_hasMore) _currentPage++;

          emit(
            CategoriesLoaded(
              categories: currentCategories,
              isLoadingMore: false,
              hasMore: _hasMore,
            ),
          );
        },
      );
    } catch (e) {
      emit(CategoriesError("Exception: $e"));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> createCategory(
    String name,
    String description,
    File imageFile,
  ) async {
    emit(CategoriesFormSubmitting());
    final result = await _createCategory(name, description, imageFile);
    result.fold(
      (failure) => emit(CategoriesFormError("Failed to create: $failure")),
      (category) {
        _categories.insert(0, category);
        emit(CategoriesFormSuccess(category));
        // Also update the loaded state
        emit(
          CategoriesLoaded(
            categories: currentCategories,
            isLoadingMore: false,
            hasMore: _hasMore,
          ),
        );
      },
    );
  }

  Future<void> updateCategory(
    int id,
    String name,
    String description,
    File imageFile,
  ) async {
    emit(CategoriesFormSubmitting());
    final result = await _updateCategory(id, name, description, imageFile);
    result.fold(
      (failure) => emit(CategoriesFormError("Failed to update: $failure")),
      (voidcategory) {
        emit(CategoriesFormSuccess(Category(id: id, name: name, description: description, imagePath: imageFile.path)));

        // Also update the loaded state
        emit(
          CategoriesLoaded(
            categories: currentCategories,
            isLoadingMore: false,
            hasMore: _hasMore,
          ),
        );
      },
    );
  }

  Future<void> deleteCategory(int id) async {
    emit(CategoryDeleting());
    final result = await _deleteCategory(id);
    result.fold(
      (failure) {
        emit(CategoryDeleteError(failure.toString()));
        // Re-emit the loaded state with current data
        emit(
          CategoriesLoaded(
            categories: currentCategories,
            isLoadingMore: false,
            hasMore: _hasMore,
          ),
        );
      },
      (_) {
        // Remove the deleted category from the list
        _categories.removeWhere((category) => category.id == id);
        // Emit deleted state first (for any UI feedback)
        emit(CategoryDeleted());
        // Then update with the current list
        emit(
          CategoriesLoaded(
            categories: currentCategories,
            isLoadingMore: false,
            hasMore: _hasMore,
          ),
        );
      },
    );
  }
}
