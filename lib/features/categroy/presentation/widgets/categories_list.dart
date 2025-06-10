import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'category_card.dart';

class CategoriesList extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategoriesList({Key? key, required this.categories}) : super(key: key);

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
