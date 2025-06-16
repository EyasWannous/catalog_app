import 'package:catalog_app/core/config/app_config.dart';
import 'package:catalog_app/core/constants/app_strings.dart';
import 'package:catalog_app/core/network/service_locator.dart';
import 'package:catalog_app/core/route/app_routes.dart';
import 'package:catalog_app/features/categroy/presentation/widgets/expandable_categories_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/sharedWidgets/custom_app_bar.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/screen_size.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenSize
    ScreenSize.init(context);

    // Use global admin configuration
    final isAdmin = AppConfig.isAdmin;
    final maxWidth = ResponsiveUtils.getMaxContentWidth(context);

    return BlocProvider(
      create:
          (context) =>
              sl<CategoriesCubit>()..getCategories(isInitialLoad: true),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: CustomAppBar(
          title: AppStrings.categoriesTitle.tr(),
          onMenuPressed: () {},
          onSearchChanged: (value) {},
          // Add admin action to app bar if needed
        ),
        floatingActionButton:
            isAdmin
                ? Builder(
                  builder:
                      (context) => FloatingActionButton(
                        onPressed: () async {
                          await context
                              .push(
                                AppRoutes.categoryForm,
                                extra: {'category': null},
                              )
                              .then((_) {
                                // This runs when returning to CategoriesScreen
                                if (context.mounted) {
                                  context.read<CategoriesCubit>().getCategories(
                                    isInitialLoad: true,
                                  );
                                }
                              });
                        },
                        backgroundColor: Color(0xFFFF8A95),
                        foregroundColor: Colors.white,
                        elevation: ResponsiveUtils.getResponsiveSpacing(
                          context,
                          6.0,
                        ),
                        child: Icon(
                          Icons.add,
                          size: ResponsiveUtils.getResponsiveIconSize(
                            context,
                            24.0,
                          ),
                        ),
                      ),
                )
                : null,
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth.toDouble()),
            child: BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state is CategoriesLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF8A95),
                          ),
                          strokeWidth: 3,
                        ),
                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            16.0,
                          ),
                        ),
                        Text(
                          'Loading categories...',
                          style: TextStyle(
                            fontSize:
                                16.0 *
                                ResponsiveUtils.getFontSizeMultiplier(context),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is CategoriesError) {
                  return Center(
                    child: Padding(
                      padding: ResponsiveUtils.getResponsivePadding(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                              ResponsiveUtils.getResponsiveSpacing(
                                context,
                                20.0,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.getResponsiveBorderRadius(
                                  context,
                                  16.0,
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.error_outline,
                              size: ResponsiveUtils.getResponsiveIconSize(
                                context,
                                64.0,
                              ),
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              16.0,
                            ),
                          ),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize:
                                  16.0 *
                                  ResponsiveUtils.getFontSizeMultiplier(
                                    context,
                                  ),
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: ResponsiveUtils.getResponsiveSpacing(
                              context,
                              24.0,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CategoriesCubit>().getCategories(
                                isInitialLoad: true,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF8A95),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    ResponsiveUtils.getResponsiveSpacing(
                                      context,
                                      24.0,
                                    ),
                                vertical: ResponsiveUtils.getResponsiveSpacing(
                                  context,
                                  12.0,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveUtils.getResponsiveBorderRadius(
                                    context,
                                    12.0,
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              AppStrings.retry.tr(),
                              style: TextStyle(
                                fontSize:
                                    16.0 *
                                    ResponsiveUtils.getFontSizeMultiplier(
                                      context,
                                    ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is CategoriesLoaded) {
                  if (state.categories.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: ResponsiveUtils.getResponsivePadding(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                ResponsiveUtils.getResponsiveSpacing(
                                  context,
                                  20.0,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveUtils.getResponsiveBorderRadius(
                                    context,
                                    16.0,
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.category_outlined,
                                size: ResponsiveUtils.getResponsiveIconSize(
                                  context,
                                  64.0,
                                ),
                                color: Colors.grey[400],
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveUtils.getResponsiveSpacing(
                                context,
                                16.0,
                              ),
                            ),
                            Text(
                              'No categories found',
                              style: TextStyle(
                                fontSize:
                                    18.0 *
                                    ResponsiveUtils.getFontSizeMultiplier(
                                      context,
                                    ),
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveUtils.getResponsiveSpacing(
                                context,
                                8.0,
                              ),
                            ),
                            Text(
                              'Categories will appear here once they are added',
                              style: TextStyle(
                                fontSize:
                                    14.0 *
                                    ResponsiveUtils.getFontSizeMultiplier(
                                      context,
                                    ),
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ExpandableCategoriesList(
                          categories: state.categories,
                          isLoadingMore: state.isLoadingMore,
                          hasMore: state.hasMore,
                          onEndReached: () {
                            context.read<CategoriesCubit>().getCategories();
                          },
                          isAdmin: isAdmin,
                        ),
                      ),
                      if (state.isLoadingMore)
                        Container(
                          padding: EdgeInsets.all(
                            ResponsiveUtils.getResponsiveSpacing(context, 16.0),
                          ),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFFF8A95),
                            ),
                            strokeWidth: 2,
                          ),
                        ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
