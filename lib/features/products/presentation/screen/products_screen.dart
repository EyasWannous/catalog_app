import 'package:catalog_app/features/products/domain/entities/product_entity.dart';
import 'package:catalog_app/features/products/presentation/bloc/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/sharedWidgets/custom_app_bar.dart';
import '../../../../core/sharedWidgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  final String? categoryTitle;

  const ProductsScreen({Key? key, this.categoryTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: categoryTitle ?? "All Products",
        onMenuPressed: () {},
        onSearchChanged: (value) {},
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
              if (state.products.products.isEmpty) {
                return _buildEmptyState(context);
              } else {
                return _buildProductGrid(state.products.products, context);
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
          // Text(
          //   'Try searching for different products',
          //   style: TextStyle(
          //     fontSize: 14 * ResponsiveUtils.getFontSizeMultiplier(context),
          //     color: Colors.grey[500],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<ProductEntity> products, BuildContext context) {
    return GridView.builder(

      padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
        top: ResponsiveUtils.getResponsiveSpacing(context, 16),
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
      ),
      itemCount: products.length,
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
        final product = products[index];
        return ProductCard(
          image: 'product.image',
          title: product.name,
          description: product.description,
          price: product.price,
          showPrice: true,
          showDescription: true,
          onTap: () {},
        );
      },
    );
  }
}
