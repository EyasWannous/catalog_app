import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../cubit/productcubit/product_cubit.dart';
import '../cubit/products_cubit.dart';
import '../widgets/widgets.dart';

class ProductScreen extends StatefulWidget {
  final int productId;
  final bool isAdmin; // Added admin flag

  const ProductScreen({
    super.key, 
    required this.productId,
    this.isAdmin = false, // Default to false
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _contentController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController, 
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController, 
      curve: Curves.easeOutCubic,
    ));

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController, 
      curve: Curves.easeOut,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _contentController.forward();
  }

  void _showDeleteDialog(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'.tr()),
        content: Text('Are you sure you want to delete this product?'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductsCubit>().deleteProduct(productId);
              Navigator.pop(context);
              context.pop(); // Return to previous screen
            },
            child: Text(
              'Delete'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const ProductLoadingWidget();
        }

        if (state is ProductLoaded) {
          final product = state.product;
          final cubit = context.read<ProductCubit>();
          final images = cubit.offers;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(product.name),
              actions: widget.isAdmin
                  ? [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => context.push(
                          AppRoutes.productForm,
                          extra: {
                            'product': product,
                            'categoryId': product.categoryId.toString(),
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(
                          context, 
                          product.id,
                        ),
                      ),
                    ]
                  : null,
            ),
            body: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveUtils.getMaxContentWidth(context),
                ),
                child: Column(
                  children: [
                    ProductImageCarousel(
                      images: images,
                      fadeAnimation: _fadeAnimation,
                      slideAnimation: _slideAnimation,
                      isAdmin: widget.isAdmin,
                      onImageDeleted: (index) {
                        // Handle image deletion using new attachment approach
                        if (index >= 0 && index < product.attachments.length) {
                          final attachmentId = product.attachments[index].id;
                          cubit.deleteAttachment(attachmentId);
                        }
                      },
                    ),
                    ProductDetailsSection(
                      product: product,
                      contentFadeAnimation: _contentFadeAnimation,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: widget.isAdmin
                ? FloatingActionButton(
                    onPressed: () => context.push(
                      AppRoutes.productForm,
                      extra: {
                        'categoryId': product.categoryId.toString(),
                      },
                    ),
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        }

        if (state is ProductError) {
          return ProductErrorWidget(message: state.message);
        }

        return const ProductLoadingWidget();
      },
    );
  }
}