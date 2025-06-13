import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'category_card.dart';

class CategoriesList extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategoriesList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: ResponsiveUtils.getMaxContentWidth(context),
      ),
      child: ListView.builder(
        padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
          top: ResponsiveUtils.getResponsiveSpacing(context, 16),
          bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryCard(category: category, index: index);
        },
      ),
    );
  }
}
