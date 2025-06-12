import 'package:catalog_app/core/route/app_routes.dart';
import 'package:catalog_app/features/categroy/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';

class CategoriesSection extends StatelessWidget {
  final List<Category> categories;

  const CategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveUtils.getResponsiveSpacing(context, 100),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: (categories.length / 2).toInt(),
        itemBuilder: (context, index) {
          return _buildCategoryItem(context, categories[index]);
        },
        separatorBuilder:
            (context, index) => SizedBox(
              width: ResponsiveUtils.getResponsiveSpacing(context, 16),
            ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category item) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            context.push(
              AppRoutes.product,
              extra: {
                'categoryName': item.name,
                "categoryId": item.id.toString(),
              },
            );
          },
          child: CircleAvatar(
            backgroundColor: Color(0xFFFFE4EC),
            radius: ResponsiveUtils.getResponsiveIconSize(context, 28),
            // backgroundImage: NetworkImage(item['icon']!),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
        Text(
          item.name,
          style: TextStyle(
            fontSize: 12 * ResponsiveUtils.getFontSizeMultiplier(context),
          ),
        ),
      ],
    );
  }
}
