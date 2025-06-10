import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../cubit/homepage_cubit.dart';

class CarouselSection extends StatefulWidget {
  final List<String> offers;
  final int currentIndex;

  const CarouselSection({
    Key? key,
    required this.offers,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _CarouselSectionState createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  final carousel.CarouselController _carouselController =
      carousel.CarouselController();

  double _getCarouselHeight(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return 180;
    } else if (ResponsiveUtils.isTablet(context)) {
      return 280;
    } else {
      return 350;
    }
  }

  @override
  Widget build(BuildContext context) {
    final carouselHeight = _getCarouselHeight(context);

    return Column(
      children: [
        Container(
          height: carouselHeight,
          child: Stack(
            children: [
              carousel.CarouselSlider(
                carouselController: _carouselController,
                options: carousel.CarouselOptions(
                  height: carouselHeight,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  enlargeCenterPage: false,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    context.read<HomepageCubit>().updateCarouselIndex(index);
                  },
                ),
                items: widget.offers.map((img) {
                  return Builder(
                    builder: (context) => Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveBorderRadius(
                            context,
                            12,
                          ),
                        ),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getResponsiveBorderRadius(
                            context,
                            12,
                          ),
                        ),
                        child: Image.network(img, fit: BoxFit.cover),
                      ),
                    ),
                  );
                }).toList(),
              ),
              _buildNavigationButton(
                isLeft: true,
                onTap: () {
                  _carouselController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                },
              ),
              _buildNavigationButton(
                isLeft: false,
                onTap: () {
                  _carouselController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.offers.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(
                entry.key,
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
              ),
              child: Container(
                width: widget.currentIndex == entry.key
                    ? ResponsiveUtils.getResponsiveSpacing(context, 24)
                    : ResponsiveUtils.getResponsiveSpacing(context, 8),
                height: ResponsiveUtils.getResponsiveSpacing(context, 8),
                margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsiveSpacing(
                    context,
                    4,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: widget.currentIndex == entry.key
                      ? Color(0xFFFFC1D4)
                      : Colors.grey[300],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNavigationButton({
    required bool isLeft,
    required VoidCallback onTap,
  }) {
    return Positioned(
      left: isLeft ? ResponsiveUtils.getResponsiveSpacing(context, 16) : null,
      right: !isLeft ? ResponsiveUtils.getResponsiveSpacing(context, 16) : null,
      top: 0,
      bottom: 0,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: ResponsiveUtils.getResponsiveIconSize(context, 40),
            height: ResponsiveUtils.getResponsiveIconSize(context, 40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isLeft ? Icons.chevron_left : Icons.chevron_right,
              color: Colors.white,
              size: ResponsiveUtils.getResponsiveIconSize(context, 24),
            ),
          ),
        ),
      ),
    );
  }
}
