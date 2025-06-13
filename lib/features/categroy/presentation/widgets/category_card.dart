import 'package:catalog_app/core/route/app_routes.dart';
import 'package:catalog_app/features/categroy/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../cubit/categories_cubit.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final int index;

  const CategoryCard({super.key, required this.category, required this.index});


  double _getCardHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1200) {
      return 220;
    } else if (ResponsiveUtils.isTablet(context)) {
      return 180;
    } else {
      return 120;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> categoryColors = [
      Color(0xFF9ED9D5), // New products
      Color(0xFFFEC78F), // Body lotions
      Color(0xFFFFE38F), // Skin care
      Color(0xFFFDB9A7), // Shampoo
      Color(0xFFE7DDCB), // Perfumes
      Color(0xFFAED6C1), // Make-up
    ];
    final i= index % categoryColors.length;

    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
      ),
      height: _getCardHeight(context),
      decoration: BoxDecoration(
        color: categoryColors[i],
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(context, 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(context, 20),
        ),
        onTap: () {
          context.push(AppRoutes.product, extra: {'categoryId': category.id.toString(), 'categoryName': category.name});
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                ResponsiveUtils.isTablet(context) ||
                        ResponsiveUtils.isDesktop(context)
                    ? 20
                    : 16,
            vertical:
                ResponsiveUtils.isTablet(context) ||
                        ResponsiveUtils.isDesktop(context)
                    ? 16
                    : 12,
          ),
          child: Row(
            children: [
              Expanded(flex: 2, child: _buildTextContent(context)),
              Expanded(
                flex: 2,
                child: _buildImageSection(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          category.name,
          style: TextStyle(
            fontSize:
                ResponsiveUtils.isTablet(context) ||
                        ResponsiveUtils.isDesktop(context)
                    ? 22 * ResponsiveUtils.getFontSizeMultiplier(context)
                    : 18 * ResponsiveUtils.getFontSizeMultiplier(context),
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        // Text(
        //   category,
        //   style: TextStyle(
        //     fontSize:
        //         ResponsiveUtils.isTablet(context) ||
        //                 ResponsiveUtils.isDesktop(context)
        //             ? 16 * ResponsiveUtils.getFontSizeMultiplier(context)
        //             : 14 * ResponsiveUtils.getFontSizeMultiplier(context),
        //     color: Colors.white.withOpacity(0.9),
        //     shadows: [
        //       Shadow(
        //         color: Colors.black.withOpacity(0.3),
        //         offset: Offset(1, 1),
        //         blurRadius: 2,
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context, {bool hasProducts=false}) {
    return Stack(
      children: [
        // Main image
        Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 12),
            ),
            child:
                hasProducts
                    ? _buildProductImage(context)
                    : _buildNoProductsPlaceholder(context),
          ),
        ),
        // Arrow icon
        _buildArrowIcon(context),
      ],
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Image.network(
      category.name,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.white.withOpacity(0.3),
          child: Icon(
            Icons.image_not_supported,
            color: Colors.white,
            size: ResponsiveUtils.getResponsiveIconSize(context, 40),
          ),
        );
      },
    );
  }

  Widget _buildNoProductsPlaceholder(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: Colors.white,
            size: ResponsiveUtils.getResponsiveIconSize(context, 30),
          ),
          SizedBox(height: 4),
          Text(
            'No Products',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10 * ResponsiveUtils.getFontSizeMultiplier(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowIcon(BuildContext context) {
    return Positioned(
      right: ResponsiveUtils.getResponsiveSpacing(context, 10),
      top: ResponsiveUtils.getResponsiveSpacing(context, 20),
      child: Container(
        padding: EdgeInsets.all(
          ResponsiveUtils.getResponsiveSpacing(context, 10),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: ResponsiveUtils.getResponsiveIconSize(context, 20),
        ),
      ),
    );
  }
}