import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/sharedWidgets/custom_app_bar.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../cubit/productcubit/product_cubit.dart';

import '../widgets/widgets.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  final bool isAdmin;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    this.isAdmin = true,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
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
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _contentController.forward();
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
          final images = product.attachments.isNotEmpty
              ? product.attachments
                    .map((attachment) => attachment.path)
                    .toList()
              : ['placeholder']; // Fallback for products without images

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              title: product.name,
              showSearch: false,
              showDrawer: false,
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
                      product: product, // Pass the product for AdminMenu
                      onImageDeleted: (index) {
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
