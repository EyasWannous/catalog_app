import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/sharedWidgets/product_card.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/route/app_routes.dart';
import '../../domain/entities/product.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;
  final ScrollController scrollController;
  final bool isLoadingMore;

  const ProductsGrid({
    super.key,
    required this.products,
    required this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: ResponsiveUtils.getMaxContentWidth(context),
      ),
      child: GridView.builder(
        controller: scrollController,
        padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
          top: ResponsiveUtils.getResponsiveSpacing(context, 16),
          bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
        ),
        itemCount: products.length + (isLoadingMore ? 1 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.getGridColumns(context),
          crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
          mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
          childAspectRatio:
              ResponsiveUtils.isTablet(context) ||
                  ResponsiveUtils.isDesktop(context)
              ? 0.75
              : 0.7,
        ),
        itemBuilder: (context, index) {
          if (index < products.length) {
            final product = products[index];
            return ProductCard(
              image: AppStrings.defaultProductImage,
              title: product.name,
              description: product.description,
              price: product.price,
              showDescription: true,
              showPrice: true,
              onTap: () {
                // Navigate to individual product screen
                context.push(
                  AppRoutes.product,
                  extra: {'productId': product.id},
                );
              },
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
