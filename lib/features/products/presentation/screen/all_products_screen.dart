import 'package:catalog_app/core/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/sharedWidgets/custom_app_bar.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/all_products_cubit.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
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
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AllProductsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
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
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is AllProductsLoaded) {
                if (state.products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentSearchQuery.isNotEmpty
                              ? 'No products found for "${_currentSearchQuery}"'
                              : 'No products available',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        if (_currentSearchQuery.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Try searching with different keywords',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
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
                              context.read<AllProductsCubit>().searchAllProducts(
                                _currentSearchQuery,
                              );
                            } else {
                              context.read<AllProductsCubit>().getAllProducts();
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
