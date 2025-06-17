import 'package:catalog_app/core/route/app_routes.dart';
import 'package:catalog_app/core/utils/logger.dart';
import 'package:catalog_app/features/category/domain/entities/category.dart';
import 'package:catalog_app/features/category/presentation/cubit/categories_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';

class HierarchicalCategoryCard extends StatelessWidget {
  final Category category;
  final int index;
  final bool isAdmin;

  const HierarchicalCategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.isAdmin,
  });

  double _getCardHeight(BuildContext context) {
    return ResponsiveUtils.isMobile(context)
        ? 100.0
        : ResponsiveUtils.isTablet(context)
        ? 140.0
        : 180.0;
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> categoryColors = [
      Color(0xFF9ED9D5), // Teal
      Color(0xFFFEC78F), // Orange
      Color(0xFFFFE38F), // Yellow
      Color(0xFFFDB9A7), // Peach
      Color(0xFFE7DDCB), // Beige
      Color(0xFFAED6C1), // Green
      Color(0xFFD7BDE2), // Purple
      Color(0xFFAED6F1), // Blue
    ];

    final colorIndex = index % categoryColors.length;
    final cardColor = categoryColors[colorIndex];

    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
      ),
      height: _getCardHeight(context),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(context, 20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 20.0),
            ),
            onTap: () => _handleCategoryTap(context),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
                vertical: ResponsiveUtils.getResponsiveSpacing(context, 12.0),
              ),
              child: Row(
                children: [
                  // Left side - Text content
                  Expanded(flex: 2, child: _buildTextContent(context)),
                  // Right side - Image and controls
                  Expanded(flex: 2, child: _buildRightSection(context)),
                ],
              ),
            ),
          ),

          // Admin controls
          if (isAdmin) _buildAdminControls(context),
        ],
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
            fontSize: 18.0 * ResponsiveUtils.getFontSizeMultiplier(context),
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4.0)),
        Text(
          category.description,
          style: TextStyle(
            fontSize: 12.0 * ResponsiveUtils.getFontSizeMultiplier(context),
            color: Colors.white.withValues(alpha: 0.9),
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.2),
                offset: Offset(0.5, 0.5),
                blurRadius: 1,
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRightSection(BuildContext context) {
    return Stack(
      children: [
        // Image section
        Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
            ),
            child: _buildImageContent(context),
          ),
        ),

        // Action icon
        _buildActionIcon(context),
      ],
    );
  }

  Widget _buildImageContent(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: Colors.white,
            size: ResponsiveUtils.getResponsiveIconSize(context, 30.0),
          ),
          SizedBox(height: 4),
          Text(
            _getActionText(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0 * ResponsiveUtils.getFontSizeMultiplier(context),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(BuildContext context) {
    return Positioned(
      right: ResponsiveUtils.getResponsiveSpacing(context, 8.0),
      top: ResponsiveUtils.getResponsiveSpacing(context, 8.0),
      child: Container(
        padding: EdgeInsets.all(
          ResponsiveUtils.getResponsiveSpacing(context, 8.0),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _hasSubcategories() ? Icons.expand_more : Icons.arrow_forward_ios,
          color: Colors.white,
          size: ResponsiveUtils.getResponsiveIconSize(context, 20.0),
        ),
      ),
    );
  }

  Widget _buildAdminControls(BuildContext context) {
    return Positioned(
      top: ResponsiveUtils.getResponsiveSpacing(context, 8.0),
      left: ResponsiveUtils.getResponsiveSpacing(context, 8.0),
      child: PopupMenuButton(
        icon: Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.getResponsiveSpacing(context, 6.0),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.more_vert,
            size: ResponsiveUtils.getResponsiveIconSize(context, 18.0),
            color: Colors.black54,
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: () => _handleEdit(context),
            child: Row(
              children: [
                Icon(Icons.edit, size: 18, color: Colors.blue),
                SizedBox(width: 8),
                Text('Edit'.tr()),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () => _handleDelete(context),
            child: Row(
              children: [
                Icon(Icons.delete, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete'.tr()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleCategoryTap(BuildContext context) async {
    final cubit = context.read<CategoriesCubit>();

    AppLogger.info(
      '🎯 HierarchicalCategoryCard tapped: ${category.name} (ID: ${category.id})',
    );

    // Check if this category has subcategories by trying to fetch them
    final hasSubcategories = await _checkForSubcategories(context, category.id);

    if (!context.mounted) return; // Guard against async context usage

    if (hasSubcategories) {
      // Navigate to subcategories
      AppLogger.info(
        '📂 Navigating to subcategories of: ${category.name} (ID: ${category.id})',
      );
      cubit.navigateToSubcategories(category);
    } else {
      // Navigate to products page
      AppLogger.info(
        '🛍️ Navigating to products for category: ${category.name} (ID: ${category.id})',
      );
      context.push(
        AppRoutes.products,
        extra: {
          'categoryId': category.id.toString(),
          'categoryName': category.name,
        },
      );
    }
  }

  Future<bool> _checkForSubcategories(
    BuildContext context,
    int categoryId,
  ) async {
    try {
      final cubit = context.read<CategoriesCubit>();
      // Use the repository to check if there are subcategories
      final result = await cubit.checkHasSubcategories(categoryId);
      return result;
    } catch (e) {
      // If there's an error, assume no subcategories and navigate to products
      AppLogger.error(
        'Error checking subcategories for category $categoryId: $e',
      );
      return false;
    }
  }

  void _handleEdit(BuildContext context) {
    final cubit = context.read<CategoriesCubit>();
    context
        .push(
          AppRoutes.categoryForm,
          extra: {'category': category, 'parentId': cubit.currentParentId},
        )
        .then((_) {
          if (context.mounted) {
            // Refresh current level
            if (cubit.isAtRootLevel) {
              cubit.getCategories(isInitialLoad: true);
            } else {
              cubit.getCategoriesByParent(
                cubit.currentParentId!,
                isInitialLoad: true,
              );
            }
          }
        });
  }

  void _handleDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete Category'.tr()),
          content: Text(
            'Are you sure you want to delete "${category.name}"?'.tr(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<CategoriesCubit>().deleteCategory(category.id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'.tr()),
            ),
          ],
        );
      },
    );
  }

  bool _hasSubcategories() {
    // This is a placeholder - the real check happens in _handleCategoryTap
    // We'll show a generic "tap to explore" message for all categories
    // The actual subcategory check is done asynchronously when tapped
    return true; // Always show as explorable, real check happens on tap
  }

  String _getActionText() {
    return 'Tap to explore';
  }
}
