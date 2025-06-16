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

class ProductsScreen extends StatelessWidget {
  final String? categoryTitle;
  final String? categoryId;

  const ProductsScreen({super.key, this.categoryTitle, this.categoryId});

  @override
  Widget build(BuildContext context) {
    // Use global admin configuration
    final isAdmin = AppConfig.isAdmin;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: categoryTitle ?? AppStrings.allProducts,
        onMenuPressed: () {},
        onSearchChanged: (value) {},
      ),

      body: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.getMaxContentWidth(context),
        ),
        child: BlocListener<ProductsCubit, ProductsState>(
          listener: (context, state) {
            if (state is ProductDeleted) {
              // Refresh the products list after successful deletion
              context.read<ProductsCubit>().getProducts(
                categoryId ?? '',
                isInitialLoad: true,
              );
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
                  categoryId: categoryId!,
                );
              }

              if (state is ProductsLoaded) {
                if (state.products.isEmpty) {
                  return EmptyState(
                    categoryTitle: categoryTitle!,
                    categoryId: categoryId!,
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: PaginatedProductsList(
                          products: state.products,
                          isLoadingMore: state.isLoadingMore,
                          hasMore: state.hasMore,
                          categoryTitle: categoryTitle,
                          categoryId: categoryId,
                          onEndReached: () {
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

              return EmptyState(
                categoryTitle: categoryTitle!,
                categoryId: categoryId!,
              );
            },
          ),
        ),
      ),
    );
  }
}
