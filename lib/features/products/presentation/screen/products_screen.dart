import 'package:catalog_app/core/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/sharedWidgets/custom_app_bar.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/products_cubit.dart';
import '../widgets/widgets.dart';

class ProductsScreen extends StatelessWidget {
  final String? categoryTitle;
  final String? categoryId;

  const ProductsScreen({super.key, this.categoryTitle, this.categoryId});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with your actual admin check logic
    final isAdmin = true; // This should come from your auth state

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: categoryTitle ?? AppStrings.allProducts,
        onMenuPressed: () {},
        onSearchChanged: (value) {},
      ),
      floatingActionButton: isAdmin
          ? Builder(
              builder: (context) => FloatingActionButton(
                onPressed: () async {
                  context.push(
                    AppRoutes.productForm,
                    extra: {'product': null, 'categoryId': categoryId},
                  );
                },
                child: const Icon(Icons.add),
              ),
            )
          : null,

      body: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.getMaxContentWidth(context),
        ),
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 64),
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                    ),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize:
                            16 * ResponsiveUtils.getFontSizeMultiplier(context),
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final extra = GoRouterState.of(context).extra;
                        String? categoryId;
                        if (extra is Map) {
                          categoryId = extra['categoryId'] as String?;
                        }
                        context.read<ProductsCubit>().getProducts(
                          categoryId ?? '',
                          isInitialLoad: true,
                        );
                      },
                      child: Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductsLoaded) {
              if (state.products.isEmpty) {
                return _buildEmptyState(context);
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: PaginatedProductsList(
                        products: state.products,
                        isLoadingMore: state.isLoadingMore,
                        hasMore: state.hasMore,
                        categoryTitle: categoryTitle,
                        onEndReached: () {
                          final extra = GoRouterState.of(context).extra;
                          String? categoryId;
                          if (extra is Map) {
                            categoryId = extra['categoryId'] as String?;
                          }
                          context.read<ProductsCubit>().getProducts(
                            categoryId ?? '',
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
            AppStrings.noProductsFound,
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
