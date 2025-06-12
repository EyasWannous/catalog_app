import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String? title;
  final String? description;
  final String? price;
  final VoidCallback? onTap;
  final bool showPrice;
  final bool showDescription;

  const ProductCard({
    key,
    required this.image,
    this.title,
    this.description,
    this.price,
    this.onTap,
    this.showPrice = false,
    this.showDescription = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      ResponsiveUtils.getResponsiveBorderRadius(context, 12),
                    ),
                    topRight: Radius.circular(
                      ResponsiveUtils.getResponsiveBorderRadius(context, 12),
                    ),
                  ),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      ResponsiveUtils.getResponsiveBorderRadius(context, 12),
                    ),
                    topRight: Radius.circular(
                      ResponsiveUtils.getResponsiveBorderRadius(context, 12),
                    ),
                  ),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: ResponsiveUtils.getResponsiveIconSize(
                            context,
                            40,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                            strokeWidth: 2,
                            color: Color(0xFFFFC1D4),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Product Details
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(
                  ResponsiveUtils.getResponsiveSpacing(context, 12),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      ResponsiveUtils.getResponsiveBorderRadius(context, 12),
                    ),
                    bottomRight: Radius.circular(
                      ResponsiveUtils.getResponsiveBorderRadius(context, 12),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product Title
                    Text(
                      title ?? "Product name here lorem ip...",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize:
                            14 * ResponsiveUtils.getFontSizeMultiplier(context),
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Product Description (if enabled)
                    if (showDescription) ...[

                      Text(
                        description ?? "Lorem ipsum dolor sit amet...",
                        style: TextStyle(
                          fontSize:
                              12 *
                              ResponsiveUtils.getFontSizeMultiplier(context),
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Product Price (if enabled)
                    if (showPrice && price != null) ...[

                      Text(
                        price!,
                        style: TextStyle(
                          fontSize:
                              16 *
                              ResponsiveUtils.getFontSizeMultiplier(context),
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFC1D4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
