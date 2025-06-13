import 'package:catalog_app/features/categroy/presentation/screen/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/sharedWidgets/custom_app_bar.dart';
import '../../../categroy/presentation/cubit/categories_cubit.dart';
import '../../../categroy/presentation/cubit/categories_state.dart';
import '../../../products/presentation/screen/products_screen.dart';
import '../widgets/section_title.dart';
import '../widgets/carousel_section.dart';
import '../widgets/categories_section.dart';
import '../widgets/products_grid_section.dart';
import '../cubit/homepage_cubit.dart';
import '../cubit/homepage_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      HomepageCubit()
        ..loadHomepageData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Catalog App",
          onMenuPressed: () {
            print("Menu pressed");
          },
          onSearchChanged: (value) {
            print("Search: $value");
          },
        ),
        body: BlocBuilder<HomepageCubit, HomepageState>(
          builder: (context, state) {
            if (state is HomepageLoading) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xFFFFC1D4)),
              );
            }

            if (state is HomepageError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomepageCubit>().refreshData();
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is HomepageLoaded) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveUtils.getMaxContentWidth(context),
                ),
                child: ListView(
                  padding: ResponsiveUtils.getResponsivePadding(
                    context,
                  ).copyWith(
                    top: ResponsiveUtils.getResponsiveSpacing(context, 16),
                    bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
                  ),
                  children: [
                    SectionTitle(
                      title: 'Best offers',
                      onSeeAllPressed: () => _navigateToProducts(context),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 10),
                    ),
                    CarouselSection(
                      offers: state.offers,
                      currentIndex: state.currentCarouselIndex,
                    ),
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 24),
                    ),

                    SectionTitle(
                      title: 'Categories',
                      onSeeAllPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriesScreen()),
                        );
                      },
                    ),
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 10),
                    ),

                    BlocBuilder<CategoriesCubit, CategoriesState>(
                      builder: (context, state) {
                        if (state is CategoriesLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFFFFC1D4)),
                          );}

                       if(state is CategoriesLoaded){
                          return CategoriesSection(categories: state.categories);
                       }
                        return SizedBox.shrink();
                      },
                    ),
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 24),
                    ),

                    SectionTitle(
                      title: 'Top products',
                      onSeeAllPressed: () => _navigateToProducts(context),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 10),
                    ),
                    ProductsGridSection(productImages: state.productImages),
                  ],
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _navigateToProducts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductsScreen()),
    );
  }
}
