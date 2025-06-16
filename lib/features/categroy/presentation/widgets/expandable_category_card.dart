import 'package:catalog_app/core/constants/app_strings.dart';
import 'package:catalog_app/core/route/app_routes.dart';
import 'package:catalog_app/features/categroy/domain/entities/category.dart';
import 'package:catalog_app/features/categroy/presentation/cubit/categories_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';

class ExpandableCategoryCard extends StatelessWidget {
  final Category category;
  final int index;
  final bool isAdmin;
  final bool isExpanded;
  final bool hasSubcategories;
  final VoidCallback onToggleExpansion;
  final bool isSubcategory;

  const ExpandableCategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.isAdmin,
    required this.isExpanded,
    required this.hasSubcategories,
    required this.onToggleExpansion,
    this.isSubcategory = false,
  });

  double _getCardHeight(BuildContext context) {
    final baseHeight =
        ResponsiveUtils.isMobile(context)
            ? 100.0
            : ResponsiveUtils.isTablet(context)
            ? 140.0
            : 180.0;
    return isSubcategory ? baseHeight * 0.8 : baseHeight;
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

    final colorIndex =
        isSubcategory
            ? (category.id % categoryColors.length)
            : (index % categoryColors.length);
    final cardColor =
        isSubcategory
            ? categoryColors[colorIndex].withValues(alpha: 0.7)
            : categoryColors[colorIndex];

    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.getResponsiveSpacing(
          context,
          isSubcategory ? 8.0 : 16.0,
        ),
      ),
      height: _getCardHeight(context),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(
            context,
            isSubcategory ? 16.0 : 20.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSubcategory ? 0.05 : 0.1),
            blurRadius: isSubcategory ? 4 : 8,
            offset: Offset(0, isSubcategory ? 2 : 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(
                context,
                isSubcategory ? 16.0 : 20.0,
              ),
            ),
            onTap:
                hasSubcategories
                    ? onToggleExpansion
                    : () {
                      context.push(
                        AppRoutes.products,
                        extra: {
                          'categoryId': category.id.toString(),
                          'categoryName': category.name,
                        },
                      );
                    },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  isSubcategory ? 12.0 : 16.0,
                ),
                vertical: ResponsiveUtils.getResponsiveSpacing(
                  context,
                  isSubcategory ? 8.0 : 12.0,
                ),
              ),
              child: Row(
                children: [
                  // Left side - Text content
                  Expanded(
                    flex: isSubcategory ? 3 : 2,
                    child: _buildTextContent(context),
                  ),

                  // Right side - Image and controls
                  Expanded(flex: 2, child: _buildRightSection(context)),
                ],
              ),
            ),
          ),

          // Admin controls
          if (isAdmin && !isSubcategory) _buildAdminControls(context),

          // Subcategory indicator
          if (isSubcategory) _buildSubcategoryIndicator(context),
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
            fontSize:
                (isSubcategory ? 14.0 : 18.0) *
                ResponsiveUtils.getFontSizeMultiplier(context),
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
        if (!isSubcategory) ...[
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

        // Action icon (expand/navigate)
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
            isSubcategory
                ? Icons.subdirectory_arrow_right
                : Icons.inventory_2_outlined,
            color: Colors.white,
            size: ResponsiveUtils.getResponsiveIconSize(
              context,
              isSubcategory ? 24.0 : 30.0,
            ),
          ),
          SizedBox(height: 4),
          if (!isSubcategory)
            Text(
              hasSubcategories ? 'Tap to expand' : AppStrings.noProducts.tr(),
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
        child: AnimatedRotation(
          turns: hasSubcategories && isExpanded ? 0.25 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            hasSubcategories
                ? (isExpanded ? Icons.expand_less : Icons.expand_more)
                : Icons.arrow_forward_ios,
            color: Colors.white,
            size: ResponsiveUtils.getResponsiveIconSize(
              context,
              isSubcategory ? 16.0 : 20.0,
            ),
          ),
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
        itemBuilder:
            (context) => [
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

  Widget _buildSubcategoryIndicator(BuildContext context) {
    return Positioned(
      top: ResponsiveUtils.getResponsiveSpacing(context, 8.0),
      left: ResponsiveUtils.getResponsiveSpacing(context, 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(context, 8.0),
          vertical: ResponsiveUtils.getResponsiveSpacing(context, 4.0),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 8.0),
          ),
        ),
        child: Text(
          'Sub',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.0 * ResponsiveUtils.getFontSizeMultiplier(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context) {
    context.push(AppRoutes.categoryForm, extra: {'category': category}).then((
      _,
    ) {
      if (context.mounted) {
        context.read<CategoriesCubit>().getCategories(isInitialLoad: true);
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
}
