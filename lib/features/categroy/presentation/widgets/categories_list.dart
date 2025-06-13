import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/category.dart';
import 'category_card.dart';

class CategoriesList extends StatelessWidget {
  final List<Category> categories;
  final ScrollController scrollController;
  final bool isLoadingMore;

   const CategoriesList({
    super.key,
    required this.categories,
    required this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: ResponsiveUtils.getMaxContentWidth(context),
      ),
      child: ListView.builder(
        controller: scrollController,
        padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
          top: ResponsiveUtils.getResponsiveSpacing(context, 16),
          bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
        ),
        itemCount: categories.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < categories.length) {
            final category = categories[index];
            return CategoryCard(category: category, index: index);
          } else {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
