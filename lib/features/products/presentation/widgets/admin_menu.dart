import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/product.dart';
import '../cubit/products_cubit.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({
    super.key,
    this.onEdit,
    this.onDelete,
    required this.product,
  });

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Product product;

  String _getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    final normalizedPath = imagePath.replaceAll('\\', '/');

    // Remove leading slash if present to avoid double slashes
    final cleanPath =
        normalizedPath.startsWith('/')
            ? normalizedPath.substring(1)
            : normalizedPath;

    return '${ApiConstants.baseImageUrl}$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(context, 8),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: Colors.white,
          size: ResponsiveUtils.getResponsiveIconSize(context, 18),
        ),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 8),
          ),
        ),
        offset: Offset(0, ResponsiveUtils.getResponsiveSpacing(context, 8)),
        onSelected: (value) {
          switch (value) {
            case 'edit':
              _editProduct(context);
              break;
            case 'delete':
              _showDeleteConfirmation(context);
              break;
          }
        },
        itemBuilder:
            (context) => [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 16),
                      color: Colors.blue[600],
                    ),
                    SizedBox(
                      width: ResponsiveUtils.getResponsiveSpacing(context, 8),
                    ),
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize:
                            14 * ResponsiveUtils.getFontSizeMultiplier(context),
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 16),
                      color: Colors.red[600],
                    ),
                    SizedBox(
                      width: ResponsiveUtils.getResponsiveSpacing(context, 8),
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontSize:
                            14 * ResponsiveUtils.getFontSizeMultiplier(context),
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
      ),
    );
  }

  void _editProduct(BuildContext context) {
    if (onEdit != null) {
      onEdit!();
    } else {
      context.push(
        AppRoutes.productForm,
        extra: {
          'product': product,
          'categoryId': product.categoryId.toString(),
        },
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.getResponsiveBorderRadius(context, 16),
              ),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange[600],
                  size: ResponsiveUtils.getResponsiveIconSize(context, 28),
                ),
                SizedBox(
                  width: ResponsiveUtils.getResponsiveSpacing(context, 12),
                ),
                Text(
                  'Delete Product',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize:
                        18 * ResponsiveUtils.getFontSizeMultiplier(context),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to delete this product?',
                  style: TextStyle(
                    fontSize:
                        16 * ResponsiveUtils.getFontSizeMultiplier(context),
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 12),
                ),
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.getResponsiveSpacing(context, 12),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getResponsiveBorderRadius(context, 8),
                    ),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveBorderRadius(context, 6),
                        ),
                        child:
                            product.attachments.isNotEmpty
                                ? Image.network(
                                  _getImageUrl(product.attachments.first.path),
                                  width: ResponsiveUtils.getResponsiveSpacing(
                                    context,
                                    40,
                                  ),
                                  height: ResponsiveUtils.getResponsiveSpacing(
                                    context,
                                    40,
                                  ),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width:
                                          ResponsiveUtils.getResponsiveSpacing(
                                            context,
                                            40,
                                          ),
                                      height:
                                          ResponsiveUtils.getResponsiveSpacing(
                                            context,
                                            40,
                                          ),
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.image,
                                        size:
                                            ResponsiveUtils.getResponsiveIconSize(
                                              context,
                                              20,
                                            ),
                                      ),
                                    );
                                  },
                                )
                                : Container(
                                  width: ResponsiveUtils.getResponsiveSpacing(
                                    context,
                                    40,
                                  ),
                                  height: ResponsiveUtils.getResponsiveSpacing(
                                    context,
                                    40,
                                  ),
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image,
                                    size: ResponsiveUtils.getResponsiveIconSize(
                                      context,
                                      20,
                                    ),
                                  ),
                                ),
                      ),
                      SizedBox(
                        width: ResponsiveUtils.getResponsiveSpacing(
                          context,
                          12,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    14 *
                                    ResponsiveUtils.getFontSizeMultiplier(
                                      context,
                                    ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '\$${product.price}',
                              style: TextStyle(
                                color: Color(0xFFFF8A95),
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    12 *
                                    ResponsiveUtils.getFontSizeMultiplier(
                                      context,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 12),
                ),
                Text(
                  'This action cannot be undone.',
                  style: TextStyle(
                    fontSize:
                        14 * ResponsiveUtils.getFontSizeMultiplier(context),
                    color: Colors.red[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize:
                        14 * ResponsiveUtils.getFontSizeMultiplier(context),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  if (onDelete != null) {
                    onDelete!();
                  } else {
                    // Default delete action using ProductsCubit
                    context.read<ProductsCubit>().deleteProduct(product.id);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getResponsiveBorderRadius(context, 8),
                    ),
                  ),
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize:
                        14 * ResponsiveUtils.getFontSizeMultiplier(context),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
