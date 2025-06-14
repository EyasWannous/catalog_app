import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/route/app_routes.dart';
import '../../domain/entities/product.dart';

class AdminProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AdminProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

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
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Admin Actions
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
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
                      child: product.attachments.isNotEmpty
                          ? Image.network(
                              product.attachments.first.path,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholderImage(context);
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return _buildLoadingImage(context, loadingProgress);
                              },
                            )
                          : _buildPlaceholderImage(context),
                    ),
                  ),
                  // Admin Actions Overlay
                  if (AppConfig.isAdmin)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: onEdit ?? () => _editProduct(context),
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 18,
                              ),
                              onPressed: onDelete ?? () => _deleteProduct(context),
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
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
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14 * ResponsiveUtils.getFontSizeMultiplier(context),
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Product Description
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 4),
                    ),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 12 * ResponsiveUtils.getFontSizeMultiplier(context),
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Product Price
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 4),
                    ),
                    Text(
                      '\$${product.price}',
                      style: TextStyle(
                        fontSize: 16 * ResponsiveUtils.getFontSizeMultiplier(context),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFC1D4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: ResponsiveUtils.getResponsiveIconSize(context, 40),
      ),
    );
  }

  Widget _buildLoadingImage(BuildContext context, ImageChunkEvent loadingProgress) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
          strokeWidth: 2,
          color: const Color(0xFFFFC1D4),
        ),
      ),
    );
  }

  void _editProduct(BuildContext context) {
    context.push(
      AppRoutes.productForm,
      extra: {
        'product': product,
        'categoryId': product.categoryId.toString(),
      },
    );
  }

  void _deleteProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete "${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement delete functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Delete functionality will be implemented'),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
