import 'package:catalog_app/features/products/presentation/cubit/products_cubit.dart';
import 'package:catalog_app/features/products/presentation/screen/paginated_products_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/sharedWidgets/custom_app_bar.dart';

class ProductsScreen extends StatefulWidget {
  final String? categoryTitle;

  const ProductsScreen({super.key, this.categoryTitle});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    // Initial load with no search
    context.read<ProductsCubit>().getProducts(
          '', // TODO: replace with real category ID if needed
          isInitialLoad: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.categoryTitle ?? "All Products",
        onMenuPressed: () {},
        onSearchChanged: (value) {
          // Update local query
          _searchQuery = value.trim();
          // Trigger Cubit with new search
          context.read<ProductsCubit>().getProducts(
                '', // TODO: replace with real category ID if needed
                isInitialLoad: true,
                searchQuery: _searchQuery,
              );
        },
      ),
      body: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.getMaxContentWidth(context),
        ),
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductsLoaded) {
              if (state.response.products.isEmpty) {
                return _buildEmptyState(context);
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: PaginatedProductsGrid(
                        products: state.response.products,
                        isLoadingMore: state.isLoadingMore,
                        hasMore: state.response.pagination.hasNextPage,
                        onEndReached: () {
                          context.read<ProductsCubit>().getProducts(
                                '', // TODO: real category ID
                                isInitialLoad: false,
                                searchQuery: _searchQuery,
                              );
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

            if (state is ProductsError) {
              return _buildEmptyState(context);
            }

            return _buildEmptyState(context);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: ResponsiveUtils.getResponsiveIconSize(context, 80),
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Text(
            'No Products Found',
            style: TextStyle(
              fontSize: 20 * ResponsiveUtils.getFontSizeMultiplier(context),
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
        ],
      ),
    );
  }
}
