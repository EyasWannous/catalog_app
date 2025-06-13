part of 'products_cubit.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final ProductsResponse response;
  final bool isLoadingMore;

  ProductsLoaded({
    required this.response,
    this.isLoadingMore = false,
  });
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});
}
