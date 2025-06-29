import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/product.dart';
import '../cubit/all_products_cubit.dart';
import 'simple_product_card.dart';

class AllProductsList extends StatefulWidget {
  final List<Product> products;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onEndReached;

  const AllProductsList({
    super.key,
    required this.products,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onEndReached,
  });

  @override
  State<AllProductsList> createState() => _AllProductsListState();
}

class _AllProductsListState extends State<AllProductsList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  void _onScroll() {
    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoadingMore) {
        widget.onEndReached();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = AppConfig.isAdmin;
    final crossAxisCount = ResponsiveUtils.getGridCrossAxisCount(context);

    return GridView.builder(
      controller: _scrollController,
      padding: ResponsiveUtils.getResponsivePadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: ResponsiveUtils.getGridChildAspectRatio(context),
        crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 12),
        mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 12),
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return SimpleProductCard(
          product: product,
          onTap: () {
            context.push(AppRoutes.product, extra: {'productId': product.id});
          },
          onEdit: isAdmin
              ? () async {
                  final result = await context.push(
                    AppRoutes.productForm,
                    extra: {
                      'product': product,
                      'categoryId': product.categoryId.toString(),
                    },
                  );

                  if (result == true && mounted) {
                    // Refresh the products list after successful edit
                    context.read<AllProductsCubit>().getAllProducts(
                      isInitialLoad: true,
                    );
                  }
                }
              : null,
          onDelete: isAdmin
              ? () {
                  _showDeleteConfirmationDialog(context, product);
                }
              : null,
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text(
            'Are you sure you want to delete "${product.name}"?\n\nThis action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AllProductsCubit>().deleteProduct(product.id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
