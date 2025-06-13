
import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}
class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
  final bool isLoadingMore;
  final bool hasMore;

  const CategoriesLoaded({
    required this.categories,
    required this.isLoadingMore,
    required this.hasMore,
  });

  @override
  List<Object> get props => [categories, isLoadingMore, hasMore];

  CategoriesLoaded copyWith({
    List<Category>? categories,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return CategoriesLoaded(
      categories: categories ?? this.categories,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}



class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object> get props => [message];
}