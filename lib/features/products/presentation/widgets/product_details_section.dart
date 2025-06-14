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
          top: ResponsiveUtils.getResponsiveSpacing(context, 24),
          bottom: ResponsiveUtils.getResponsiveSpacing(context, 24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Product name
            _buildAnimatedProductName(context),

            // Animated Price and Rating
            _buildAnimatedPriceAndRating(context),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),

            // Staggered animated description sections
            ..._buildAnimatedDescriptions(context, [
              "Lorem ipsum here. Lorem ipsum dolor sit amet consectetur.",
              "Quasi sunt error et eum consectetur. Dignissimos omnis vel molestias sit laborum maxime molestiae sed accusamus. Ipsam excepteur mollitia expedita sed sint sint consequatur consectetur dignissimos omnis qui dolor sit amet, consectetur adipiscing elit. laborum maxime expedita sed.",
              "Quasi sunt error et eum consectetur. Dignissimos omnis vel molestias sit.",
              product.description,
              "Quasi sunt error et eum consectetur. Dignissimos omnis vel molestias sit laborum maxime molestiae sed accusamus.",
              "Ipsam excepteur mollitia expedita sed sint sint consequatur consectetur dignissimos omnis qui dolor sit amet, consectetur adipiscing elit.",
              "Quasi sunt error et eum consectetur. Dignissimos omnis vel molestias sit laborum maxime molestiae sed accusamus. Ipsam excepteur mollitia expedita sed sint sint consequatur consectetur dignissimos omnis qui dolor sit amet consectetur adipiscing elit. Quasi sunt error et eum consectetur aliquid.",
              "Quasi sunt error et eum consectetur. Dignissimos omnis vel molestias sit laborum maxime molestiae sed accusamus consectetur dignissimos omnis.",
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedProductName(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Text(
              product.name,
              style: TextStyle(
                fontSize: 20 * ResponsiveUtils.getFontSizeMultiplier(context),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedPriceAndRating(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Row(
              children: [
                // Price
                Text(
                  product.price,
                  style: TextStyle(
                    fontSize:
                        24 * ResponsiveUtils.getFontSizeMultiplier(context),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF8A95),
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                // Rating
                _buildRatingStars(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingStars(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          if (index < product.rating.floor()) {
            return Icon(
              Icons.star,
              size: ResponsiveUtils.getResponsiveIconSize(context, 16),
              color: Colors.amber,
            );
          } else if (index < product.rating) {
            return Icon(
              Icons.star_half,
              size: ResponsiveUtils.getResponsiveIconSize(context, 16),
              color: Colors.amber,
            );
          } else {
            return Icon(
              Icons.star_border,
              size: ResponsiveUtils.getResponsiveIconSize(context, 16),
              color: Colors.grey[400],
            );
          }
        }),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 6)),
        Text(
          '(${product.rating.toStringAsFixed(1)})',
          style: TextStyle(
            fontSize: 14 * ResponsiveUtils.getFontSizeMultiplier(context),
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAnimatedDescriptions(
    BuildContext context,
    List<String> descriptions,
  ) {
    return descriptions.asMap().entries.map((entry) {
      final index = entry.key;
      final text = entry.value;

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 800 + (index * 100)),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: _buildDescriptionSection(context, text),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildDescriptionSection(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14 * ResponsiveUtils.getFontSizeMultiplier(context),
          color: Colors.black54,
          height: 1.6,
        ),
      ),
    );
  }
}
