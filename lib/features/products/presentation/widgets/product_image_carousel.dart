import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/product.dart';
import '../cubit/products_cubit.dart';
import 'admin_menu.dart';
import 'animated_navigation_button.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final bool isAdmin;
  final Function(int)? onImageDeleted;
  final Product? product;

  const ProductImageCarousel({
    super.key,
    required this.images,
    required this.fadeAnimation,
    required this.slideAnimation,
    this.isAdmin = false,
    this.onImageDeleted,
    this.product,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  late CarouselSliderController carouselController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    carouselController = CarouselSliderController();
  }

  String _getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    // Convert backslashes to forward slashes for URL
    final normalizedPath = imagePath.replaceAll('\\', '/');

    // Remove leading slash if present to avoid double slashes
    final cleanPath =
        normalizedPath.startsWith('/')
            ? normalizedPath.substring(1)
            : normalizedPath;

    return '${ApiConstants.baseImageUrl}$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    final hasMultipleImages = widget.images.length > 1;

    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: Container(
          width: double.infinity,
          height:
              ResponsiveUtils.isMobile(context)
                  ? 380
                  : ResponsiveUtils.isTablet(context)
                  ? 450
                  : 500,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: ResponsiveUtils.getResponsiveSpacing(context, 20),
                    bottom: ResponsiveUtils.getResponsiveSpacing(context, 60),
                    left: ResponsiveUtils.getResponsiveSpacing(context, 16),
                    right: ResponsiveUtils.getResponsiveSpacing(context, 16),
                  ),
                  child:
                      hasMultipleImages
                          ? CarouselSlider(
                            carouselController: carouselController,
                            options: CarouselOptions(
                              height: double.infinity,
                              viewportFraction: 1.0,
                              enableInfiniteScroll: widget.images.length > 2,
                              autoPlay: false,
                              enlargeCenterPage: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                            items:
                                widget.images.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final url = entry.value;
                                  return Hero(
                                    tag: 'product_image_$index',
                                    child: _buildCarouselItem(
                                      context,
                                      url,
                                      index,
                                    ),
                                  );
                                }).toList(),
                          )
                          : Hero(
                            tag: 'product_image_0',
                            child: _buildCarouselItem(
                              context,
                              widget.images.first,
                              0,
                            ),
                          ),
                ),
              ),

              if (!ResponsiveUtils.isMobile(context) && hasMultipleImages)
                Positioned(
                  left: ResponsiveUtils.getResponsiveSpacing(context, 8),
                  top: 0,
                  bottom: ResponsiveUtils.getResponsiveSpacing(context, 60),
                  child: Center(
                    child: AnimatedNavigationButton(
                      onTap:
                          () => carouselController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          ),
                      icon: Icons.arrow_back_ios_new,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 40),
                      iconSize: ResponsiveUtils.getResponsiveIconSize(
                        context,
                        18,
                      ),
                    ),
                  ),
                ),

              if (!ResponsiveUtils.isMobile(context) && hasMultipleImages)
                Positioned(
                  right: ResponsiveUtils.getResponsiveSpacing(context, 8),
                  top: 0,
                  bottom: ResponsiveUtils.getResponsiveSpacing(context, 60),
                  child: Center(
                    child: AnimatedNavigationButton(
                      onTap:
                          () => carouselController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          ),
                      icon: Icons.arrow_forward_ios,
                      size: ResponsiveUtils.getResponsiveIconSize(context, 40),
                      iconSize: ResponsiveUtils.getResponsiveIconSize(
                        context,
                        18,
                      ),
                    ),
                  ),
                ),

              // Admin Menu for product actions
              if (AppConfig.isAdmin && widget.product != null)
                Positioned(
                  top: ResponsiveUtils.getResponsiveSpacing(context, 8),
                  right: ResponsiveUtils.getResponsiveSpacing(context, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.getResponsiveBorderRadius(context, 8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        context.push(
                          AppRoutes.productForm,
                          extra: {
                            'product': widget.product,
                            'categoryId': widget.product!.categoryId.toString(),
                          },
                        );
                      },
                    ),
                  ),
                ),

              // Navigation Dots - only show if multiple images
              if (hasMultipleImages)
                Positioned(
                  bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
                  left: 0,
                  right: 0,
                  child: _buildNavigationDots(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, String url, int index) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(context, 2),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 20),
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Image.network(
                    _getImageUrl(url),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          color: Colors.grey[50],
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, opacity, child) {
                              return Opacity(
                                opacity: opacity,
                                child: Icon(
                                  Icons.image_outlined,
                                  size: ResponsiveUtils.getResponsiveIconSize(
                                    context,
                                    60,
                                  ),
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildAdminControls(BuildContext context) {
  //   return TweenAnimationBuilder<double>(
  //     tween: Tween(begin: 0.0, end: 1.0),
  //     duration: const Duration(milliseconds: 500),
  //     builder: (context, value, child) {
  //       return Transform.scale(
  //         scale: value,
  //         child: Opacity(
  //           opacity: value,
  //           child: Container(
  //             padding: EdgeInsets.all(
  //               ResponsiveUtils.getResponsiveSpacing(context, 4),
  //             ),
  //             decoration: BoxDecoration(
  //               color: Colors.black.withValues(alpha: 0.5),
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 IconButton(
  //                   icon: Icon(
  //                     Icons.delete,
  //                     size: ResponsiveUtils.getResponsiveIconSize(context, 24),
  //                     color: Colors.white,
  //                   ),
  //                   onPressed: () {
  //                     if (widget.onImageDeleted != null) {
  //                       widget.onImageDeleted!(currentIndex);
  //                     }
  //                   },
  //                 ),
  //                 if (widget.images.length > 1)
  //                   IconButton(
  //                     icon: Icon(
  //                       Icons.swap_horiz,
  //                       size: ResponsiveUtils.getResponsiveIconSize(
  //                         context,
  //                         24,
  //                       ),
  //                       color: Colors.white,
  //                     ),
  //                     onPressed: () {
  //                       // Implement image reordering if needed
  //                     },
  //                   ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildNavigationDots(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left arrow (mobile only) - only show if multiple images
                if (ResponsiveUtils.isMobile(context) &&
                    widget.images.length > 1)
                  AnimatedNavigationButton(
                    onTap:
                        () => carouselController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        ),
                    icon: Icons.arrow_back_ios_new,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 32),
                    iconSize: ResponsiveUtils.getResponsiveIconSize(
                      context,
                      14,
                    ),
                    isSmall: true,
                  ),

                // Dots container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsiveSpacing(
                      context,
                      12,
                    ),
                    vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getResponsiveBorderRadius(context, 16),
                    ),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        widget.images.asMap().entries.map((entry) {
                          final isActive = entry.key == currentIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width:
                                isActive
                                    ? ResponsiveUtils.getResponsiveSpacing(
                                      context,
                                      16,
                                    )
                                    : ResponsiveUtils.getResponsiveSpacing(
                                      context,
                                      8,
                                    ),
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              8,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.getResponsiveSpacing(
                                context,
                                2,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color:
                                  isActive
                                      ? const Color(0xFFFF8A95)
                                      : Colors.grey.withValues(alpha: 0.4),
                            ),
                          );
                        }).toList(),
                  ),
                ),

                // Right arrow (mobile only) - only show if multiple images
                if (ResponsiveUtils.isMobile(context) &&
                    widget.images.length > 1)
                  AnimatedNavigationButton(
                    onTap:
                        () => carouselController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        ),
                    icon: Icons.arrow_forward_ios,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 32),
                    iconSize: ResponsiveUtils.getResponsiveIconSize(
                      context,
                      14,
                    ),
                    isSmall: true,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
