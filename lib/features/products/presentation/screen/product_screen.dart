import 'package:catalog_app/core/utils/responsive_utils.dart';
import 'package:catalog_app/features/products/presentation/cubit/productcubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductScreen extends StatelessWidget {
  final int productId;
  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit()..getProduct(productId),
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProductLoaded) {
            final product = state.product;
            final images =  ProductCubit().offers;// product.images;
            final currentIndex = ProductCubit().currentIndex;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.pink[100],
                title: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                    ),
                    const SizedBox(width: 10),
                    const Text("Logo", style: TextStyle(color: Colors.white)),
                  ],
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.menu, color: Colors.white),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveUtils.getMaxContentWidth(context),
                  ),
                  padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
                    top: ResponsiveUtils.getResponsiveSpacing(context, 16),
                    bottom: ResponsiveUtils.getResponsiveSpacing(context, 32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Carousel ---
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveBorderRadius(context, 16),
                        ),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: ResponsiveUtils.isMobile(context) ? 250 : 400,
                            viewportFraction: 1.0,
                            onPageChanged: (index, _) {
                              context.read<ProductCubit>().setImageIndex(index);
                            },
                          ),
                          items: images.map((url) {
                            return Image.network(
                              url,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),

                      // --- Indicators ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images.asMap().entries.map((entry) {
                          final isActive = entry.key == currentIndex;
                          return GestureDetector(
                            onTap: () => context.read<ProductCubit>().setImageIndex(entry.key),
                            child: Container(
                              width: ResponsiveUtils.isMobile(context) ? 8 : 12,
                              height: ResponsiveUtils.isMobile(context) ? 8 : 12,
                              margin: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.getResponsiveSpacing(context, 4),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive ? Colors.pinkAccent : Colors.grey[300],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),

                      // --- Name ---
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 22 * ResponsiveUtils.getFontSizeMultiplier(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

                      // --- Description ---
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 16 * ResponsiveUtils.getFontSizeMultiplier(context),
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

                      // --- Price (if you have one) ---
                      // if (product.price != null) ...[
                      //   Text(
                      //     "\$${product.price!.toStringAsFixed(2)}",
                      //     style: TextStyle(
                      //       fontSize: 20 * ResponsiveUtils.getFontSizeMultiplier(context),
                      //       fontWeight: FontWeight.w600,
                      //       color: Colors.pinkAccent,
                      //     ),
                      //   ),
                      //   SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
                      // ],
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is ProductError) {
            return Scaffold(
              appBar: AppBar(backgroundColor: Colors.pink[100], title: const Text("Product")),
              body: Center(
                child: Padding(
                  padding: ResponsiveUtils.getResponsivePadding(context),
                  child: Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 18 * ResponsiveUtils.getFontSizeMultiplier(context),
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }

          // fallback
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
