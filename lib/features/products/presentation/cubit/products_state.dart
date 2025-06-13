part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}
final class ProductsLoading extends ProductsState {}
final class ProductsLoaded extends ProductsState {
  final ProductsResponse products;

  ProductsLoaded({required this.products});
}
final class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});
}

class ProductFormSubmitting extends ProductsState {}

class ProductFormSuccess extends ProductsState {
  final Product product;

  ProductFormSuccess({required this.product});
}

class ProductFormError extends ProductsState {
  final String message;

  ProductFormError({required this.message});
}

class ProductDeleting extends ProductsState {}

class ProductDeleted extends ProductsState {}

class ProductDeleteError extends ProductsState {
  final String message;
  ProductDeleteError({required this.message});
}