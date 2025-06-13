import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/sharedWidgets/product_card.dart';
import '../../../products/presentation/screen/products_screen.dart';

class ProductsGridSection extends StatelessWidget {
  final List<String> productImages;

  const ProductsGridSection({super.key, required this.productImages});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: productImages.length * 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.getGridColumns(context),
        crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 12),
        mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 12),
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        String img = productImages[index % productImages.length];
        return ProductCard(
          image: img,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductsScreen()),
            );
          },
        );
      },
    );
  }
}
