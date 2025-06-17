import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/product.dart';

class ProductDetailsSection extends StatelessWidget {
  final Product product;
  final Animation<double> contentFadeAnimation;

  const ProductDetailsSection({
    super.key,
    required this.product,
    required this.contentFadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: contentFadeAnimation,
      child: Container(
        width: double.infinity,
        padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
          top: ResponsiveUtils.getResponsiveSpacing(context, 32),
          bottom: ResponsiveUtils.getResponsiveSpacing(context, 32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with   product name and price
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name (left side)
                Expanded(child: _buildProductName(context)),

                SizedBox(
                  width: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),

                // Price section (right side)
                _buildPriceSection(context),
              ],
            ),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

            // Product description with clean layout
            _buildProductDescription(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductName(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Text(
              product.name,
              style: TextStyle(
                fontSize: 24 * ResponsiveUtils.getFontSizeMultiplier(context),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.3,
                letterSpacing: -0.3,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductDescription(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 15 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Text(
              product.description.isNotEmpty
                  ? product.description
                  : 'Premium quality product with excellent features and modern design.',
              style: TextStyle(
                fontSize: 16 * ResponsiveUtils.getFontSizeMultiplier(context),
                color: Colors.grey[600],
                height: 1.5,
                letterSpacing: 0.1,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 15 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsiveSpacing(context, 20),
                vertical: ResponsiveUtils.getResponsiveSpacing(context, 12),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC1D4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getResponsiveBorderRadius(context, 25),
                ),
                border: Border.all(
                  color: const Color(0xFFFFC1D4).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontSize:
                          20 * ResponsiveUtils.getFontSizeMultiplier(context),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFF8A95),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
