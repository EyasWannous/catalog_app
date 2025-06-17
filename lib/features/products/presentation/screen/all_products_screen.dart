import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/shared_widgets/empty_state_widget.dart';
import '../../../../core/shared_widgets/error_state_widget.dart';
import '../../../../core/shared_widgets/loading_state_widget.dart';
import '../../../../core/sharedWidgets/custom_app_bar.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../cubit/all_products_cubit.dart';
import '../widgets/widgets.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
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
          context.read<AllProductsCubit>().searchAllProducts(
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
        title: AppStrings.allProducts,
        searchController: _searchController,
        onMenuPressed: () {},
        onSearchChanged: _onSearchChanged,
        searchHint: 'Search all products...',
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () async {
                final result = await context.push(
                  AppRoutes.productForm,
                  extra: {'product': null, 'categoryId': null},
                );

                if (result == true && mounted) {
                  context.read<AllProductsCubit>().getAllProducts(
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
        child: BlocListener<AllProductsCubit, AllProductsState>(
          listener: (context, state) {
            if (state is AllProductDeleted) {
              // Refresh the products list after successful deletion
              if (_currentSearchQuery.isNotEmpty) {
                context.read<AllProductsCubit>().searchAllProducts(
                  _currentSearchQuery,
                  isInitialLoad: true,
                );
              } else {
                context.read<AllProductsCubit>().getAllProducts(
                  isInitialLoad: true,
                );
              }
            } else if (state is AllProductDeleteError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 8),
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
          child: BlocBuilder<AllProductsCubit, AllProductsState>(
            builder: (context, state) {
              if (state is AllProductsLoading) {
                return LoadingStateVariants.medium(
                  message: 'Loading products...',
                );
              }

              if (state is AllProductsError) {
                return ErrorStateVariants.generic(
                  message: state.message,
                  onRetry: () {
                    if (_currentSearchQuery.isNotEmpty) {
                      context.read<AllProductsCubit>().searchAllProducts(
                        _currentSearchQuery,
                        isInitialLoad: true,
                      );
                    } else {
                      context.read<AllProductsCubit>().getAllProducts(
                        isInitialLoad: true,
                      );
                    }
                  },
                );
              }

              if (state is AllProductsLoaded) {
                if (state.products.isEmpty) {
                  return _currentSearchQuery.isNotEmpty
                      ? EmptyStateVariants.search(searchTerm: _currentSearchQuery)
                      : EmptyStateVariants.products(
                          onAddProduct: AppConfig.isAdmin
                              ? () async {
                                  final result = await context.push(
                                    AppRoutes.productForm,
                                    extra: {'product': null, 'categoryId': null},
                                  );
                                  if (result == true && mounted) {
                                    context.read<AllProductsCubit>().getAllProducts(
                                      isInitialLoad: true,
                                    );
                                  }
                                }
                              : null,
                        );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: AllProductsList(
                          products: state.products,
                          isLoadingMore: state.isLoadingMore,
                          hasMore: state.hasMore,
                          onEndReached: () {
                            if (_currentSearchQuery.isNotEmpty) {
                              context
                                  .read<AllProductsCubit>()
                                  .searchAllProducts(_currentSearchQuery);
                            } else {
                              context.read<AllProductsCubit>().getAllProducts();
                            }
                          },
                        ),
                      ),
                      if (state.isLoadingMore)
                        LoadingStateVariants.small(
                          message: 'Loading more products...',
                        ),
                    ],
                  );
                }
              }

              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Welcome to Products',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
