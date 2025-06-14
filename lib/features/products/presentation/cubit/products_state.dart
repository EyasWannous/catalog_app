part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool isLoadingMore;
  final bool hasMore;

  ProductsLoaded({
    required this.products,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

final class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});
}
