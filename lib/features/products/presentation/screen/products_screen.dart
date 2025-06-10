import 'package:flutter/material.dart';
import '../../../../core/sharedWidgets/custom_app_bar.dart';
import '../../../../core/sharedWidgets/product_card.dart';
import '../../../../core/utils/responsive_utils.dart';

class ProductsScreen extends StatefulWidget {
  final String? categoryTitle;

  const ProductsScreen({Key? key, this.categoryTitle}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'title': 'Moisturizing Body Lotion',
      'description': 'Nourishing formula for soft, smooth skin',
      'price': '\$24.99',
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'category': 'Body lotions',
    },
    {
      'id': '2',
      'title': 'Vitamin C Serum',
      'description': 'Brightening serum for radiant skin',
      'price': '\$32.50',
      'image':
          'https://images.unsplash.com/photo-1570194065650-d99fb4bedf0a?w=400&h=300&fit=crop',
      'category': 'Skin care',
    },
    {
      'id': '3',
      'title': 'Hydrating Shampoo',
      'description': 'Gentle cleansing for all hair types',
      'price': '\$18.99',
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'category': 'Shampoo',
    },
    {
      'id': '4',
      'title': 'Luxury Perfume',
      'description': 'Elegant fragrance for special occasions',
      'price': '\$89.99',
      'image':
          'https://images.unsplash.com/photo-1541643600914-78b084683601?w=400&h=300&fit=crop',
      'category': 'Perfume',
    },
    {
      'id': '5',
      'title': 'Anti-Aging Cream',
      'description': 'Reduces fine lines and wrinkles',
      'price': '\$45.00',
      'image':
          'https://images.unsplash.com/photo-1570194065650-d99fb4bedf0a?w=400&h=300&fit=crop',
      'category': 'Skin care',
    },
    {
      'id': '6',
      'title': 'Organic Body Butter',
      'description': 'Rich, creamy texture for dry skin',
      'price': '\$28.75',
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'category': 'Body lotions',
    },
    {
      'id': '7',
      'title': 'Color Correcting Shampoo',
      'description': 'Maintains vibrant hair color',
      'price': '\$22.99',
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'category': 'Shampoo',
    },
    {
      'id': '8',
      'title': 'Fresh Eau de Toilette',
      'description': 'Light, refreshing daily fragrance',
      'price': '\$65.00',
      'image':
          'https://images.unsplash.com/photo-1541643600914-78b084683601?w=400&h=300&fit=crop',
      'category': 'Perfume',
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    if (widget.categoryTitle == null || widget.categoryTitle!.isEmpty) {
      return products;
    }
    return products
        .where(
          (product) => product['category'].toString().toLowerCase().contains(
            widget.categoryTitle!.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayProducts = filteredProducts;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.categoryTitle ?? "All Products",
        onMenuPressed: () {
        },
        onSearchChanged: (value) {
        },
      ),
      body: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.getMaxContentWidth(context),
        ),
        child:
            displayProducts.isEmpty
                ? _buildEmptyState()
                : _buildProductGrid(displayProducts),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: ResponsiveUtils.getResponsiveIconSize(context, 80),
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Text(
            'No Products Found',
            style: TextStyle(
              fontSize: 20 * ResponsiveUtils.getFontSizeMultiplier(context),
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          Text(
            'Try searching for different products',
            style: TextStyle(
              fontSize: 14 * ResponsiveUtils.getFontSizeMultiplier(context),
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Map<String, dynamic>> products) {
    return GridView.builder(
      padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
        top: ResponsiveUtils.getResponsiveSpacing(context, 16),
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
      ),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.getGridColumns(context),
        crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
        mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
        childAspectRatio:
            ResponsiveUtils.isTablet(context) ||
                    ResponsiveUtils.isDesktop(context)
                ? 0.75
                : 0.7,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          image: product['image'],
          title: product['title'],
          description: product['description'],
          price: product['price'],
          showPrice: true,
          showDescription: true,
          onTap: () {},
        );
      },
    );
  }
}
