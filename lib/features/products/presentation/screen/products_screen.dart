import 'package:catalog_app/core/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/sharedWidgets/custom_app_bar.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/products_cubit.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../widgets/widgets.dart';

class ProductsScreen extends StatefulWidget {
  final String? categoryTitle;
  final String? categoryId;

  const ProductsScreen({super.key, this.categoryTitle, this.categoryId});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentSearchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query != _currentSearchQuery) {
      _currentSearchQuery = query;
      // Debounce search to avoid too many API calls
      Future.delayed(const Duration(milliseconds: 500), () {
        if (query == _currentSearchQuery && mounted) {
          context.read<ProductsCubit>().searchProducts(
            widget.categoryId ?? '',
            query.trim(),
            isInitialLoad: true,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use global admin configuration
    final isAdmin = AppConfig.isAdmin;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.categoryTitle ?? AppStrings.allProducts,
        searchController: _searchController,
        onMenuPressed: () {},
        onSearchChanged: _onSearchChanged,
        searchHint:
            'Search products in ${widget.categoryTitle ?? 'category'}...',
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () async {
                final result = await context.push(
                  AppRoutes.productForm,
                  extra: {'product': null, 'categoryId': widget.categoryId},
                );

                if (result == true && mounted) {
                  context.read<ProductsCubit>().getProducts(
                    widget.categoryId ?? '',
                    isInitialLoad: true,
                  );
                }
              },
              backgroundColor: const Color(0xFFFFC1D4),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

      body: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.getMaxContentWidth(context),
        ),
        child: BlocListener<ProductsCubit, ProductsState>(
          listener: (context, state) {
            if (state is ProductDeleted) {
              // Refresh the products list after successful deletion
              if (_currentSearchQuery.isNotEmpty) {
                context.read<ProductsCubit>().searchProducts(
                  widget.categoryId ?? '',
                  _currentSearchQuery,
                  isInitialLoad: true,
                );
              } else {
                context.read<ProductsCubit>().getProducts(
                  widget.categoryId ?? '',
                  isInitialLoad: true,
                );
              }
            } else if (state is ProductDeleteError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.error, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Failed to delete product: ${state.message}',
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProductsError) {
                return ErrorState(
                  message: state.message,
                  categoryId: widget.categoryId!,
                );
              }

              if (state is ProductsLoaded) {
                if (state.products.isEmpty) {
                  return EmptyState(
                    categoryTitle: widget.categoryTitle!,
                    categoryId: widget.categoryId!,
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: PaginatedProductsList(
                          products: state.products,
                          isLoadingMore: state.isLoadingMore,
                          hasMore: state.hasMore,
                          categoryTitle: widget.categoryTitle,
                          categoryId: widget.categoryId,
                          onEndReached: () {
                            if (_currentSearchQuery.isNotEmpty) {
                              context.read<ProductsCubit>().searchProducts(
                                widget.categoryId ?? '',
                                _currentSearchQuery,
                              );
                            } else {
                              context.read<ProductsCubit>().getProducts(
                                widget.categoryId ?? '',
                              );
                            }
                          },
                        ),
                      ),
                      if (state.isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  );
                }
              }

              return EmptyState(
                categoryTitle: widget.categoryTitle!,
                categoryId: widget.categoryId!,
              );
            },
          ),
        ),
      ),
    );
  }
}
