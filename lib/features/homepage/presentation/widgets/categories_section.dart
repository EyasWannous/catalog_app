import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';

class CategoriesSection extends StatelessWidget {
  final List<Map<String, String>> categories;

  const CategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveUtils.getResponsiveSpacing(context, 100),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length * 2,
        itemBuilder: (context, index) {
          var item = categories[index % categories.length];
          return _buildCategoryItem(context, item);
        },
        separatorBuilder:
            (context, index) => SizedBox(
              width: ResponsiveUtils.getResponsiveSpacing(context, 16),
            ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, Map<String, String> item) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Color(0xFFFFE4EC),
          radius: ResponsiveUtils.getResponsiveIconSize(context, 28),
          backgroundImage: NetworkImage(item['icon']!),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
        Text(
          item['label']!,
          style: TextStyle(
            fontSize: 12 * ResponsiveUtils.getFontSizeMultiplier(context),
          ),
        ),
      ],
    );
  }
}
