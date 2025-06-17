import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:catalog_app/core/config/app_config.dart';
import 'package:catalog_app/core/constants/app_strings.dart';
import 'package:catalog_app/core/network/service_locator.dart';
import 'package:catalog_app/core/route/app_routes.dart';
import 'package:catalog_app/core/sharedWidgets/custom_app_bar.dart';
import 'package:catalog_app/core/utils/responsive_utils.dart';
import 'package:catalog_app/core/utils/screen_size.dart';
import 'package:catalog_app/features/category/presentation/cubit/categories_cubit.dart';
import 'package:catalog_app/features/category/presentation/widgets/hierarchical_category_card.dart';
import '../cubit/categories_state.dart';

class HierarchicalCategoriesScreen extends StatelessWidget {
  const HierarchicalCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenSize
    ScreenSize.init(context);

    // Use global admin configuration
    final isAdmin = AppConfig.isAdmin;
    final maxWidth = ResponsiveUtils.getMaxContentWidth(context);

    return BlocProvider(
      create: (context) =>
          sl<CategoriesCubit>()..getCategories(isInitialLoad: true),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(context),
        floatingActionButton: isAdmin
            ? _buildFloatingActionButton(context)
            : null,
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth.toDouble()),
            child: Column(
              children: [
                // Breadcrumb navigation
                _buildBreadcrumbNavigation(context),
                // Categories list
                Expanded(
                  child: BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, state) {
                      return _buildCategoriesContent(context, state, isAdmin);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: AppStrings.categoriesTitle.tr(),
      onMenuPressed: () {},
      onSearchChanged: null, // ✅ Disabled search as requested
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Builder(
      builder: (context) => FloatingActionButton(
        onPressed: () async {
          final cubit = context.read<CategoriesCubit>();
          await context
              .push(
                AppRoutes.categoryForm,
                extra: {
                  'category': null,
                  'parentId': cubit
                      .currentParentId, // Pass current parent for hierarchy
                },
              )
              .then((_) {
                if (context.mounted) {
                  // Refresh current level
                  if (cubit.isAtRootLevel) {
                    cubit.getCategories(isInitialLoad: true);
                  } else {
                    cubit.getCategoriesByParent(
                      cubit.currentParentId!,
                      isInitialLoad: true,
                    );
                  }
                }
              });
        },
        backgroundColor: Color(0xFFFF8A95),
        foregroundColor: Colors.white,
        elevation: ResponsiveUtils.getResponsiveSpacing(context, 6.0),
        child: Icon(
          Icons.add,
          size: ResponsiveUtils.getResponsiveIconSize(context, 24.0),
        ),
      ),
    );
  }

  Widget _buildBreadcrumbNavigation(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        final cubit = context.read<CategoriesCubit>();
        final navigationStack = cubit.navigationStack;

        if (navigationStack.isEmpty) {
          return const SizedBox.shrink(); // No breadcrumb at root level
        }

        return Container(
          width: double.infinity,
          padding: ResponsiveUtils.getResponsivePadding(context),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: Row(
            children: [
              // Back button
              IconButton(
                onPressed: () => cubit.navigateBack(),
                icon: Icon(Icons.arrow_back, color: Color(0xFFFF8A95)),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              SizedBox(width: 8),

              // Breadcrumb text
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Root level
                      GestureDetector(
                        onTap: () => cubit.navigateToRoot(),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            color: Color(0xFFFF8A95),
                            fontSize:
                                14 *
                                ResponsiveUtils.getFontSizeMultiplier(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Navigation stack
                      ...navigationStack.map((category) {
                        final isLast = category == navigationStack.last;
                        return Row(
                          children: [
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey[400],
                              size: 16,
                            ),
                            Text(
                              category.name,
                              style: TextStyle(
                                color: isLast
                                    ? Colors.black87
                                    : Color(0xFFFF8A95),
                                fontSize:
                                    14 *
                                    ResponsiveUtils.getFontSizeMultiplier(
                                      context,
                                    ),
                                fontWeight: isLast
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesContent(
    BuildContext context,
    CategoriesState state,
    bool isAdmin,
  ) {
    if (state is CategoriesLoading) {
      return _buildLoadingState(context);
    }

    if (state is CategoriesError) {
      return _buildErrorState(context, state.message);
    }

    if (state is CategoriesLoaded) {
      if (state.categories.isEmpty) {
        return _buildEmptyState(context);
      }

      return _buildCategoriesList(
        context,
        state.categories,
        state.isLoadingMore,
        state.hasMore,
        isAdmin,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8A95)),
            strokeWidth: 3,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16.0)),
          Text(
            'Loading categories...',
            style: TextStyle(
              fontSize: 16.0 * ResponsiveUtils.getFontSizeMultiplier(context),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(
                ResponsiveUtils.getResponsiveSpacing(context, 20.0),
              ),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getResponsiveBorderRadius(context, 16.0),
                ),
              ),
              child: Icon(
                Icons.error_outline,
                size: ResponsiveUtils.getResponsiveIconSize(context, 64.0),
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
            ),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.0 * ResponsiveUtils.getFontSizeMultiplier(context),
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 24.0),
            ),
            ElevatedButton(
              onPressed: () {
                final cubit = context.read<CategoriesCubit>();
                if (cubit.isAtRootLevel) {
                  cubit.getCategories(isInitialLoad: true);
                } else {
                  cubit.getCategoriesByParent(
                    cubit.currentParentId!,
                    isInitialLoad: true,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF8A95),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsiveSpacing(
                    context,
                    24.0,
                  ),
                  vertical: ResponsiveUtils.getResponsiveSpacing(context, 12.0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.getResponsiveBorderRadius(context, 12.0),
                  ),
                ),
              ),
              child: Text(
                AppStrings.retry.tr(),
                style: TextStyle(
                  fontSize:
                      16.0 * ResponsiveUtils.getFontSizeMultiplier(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final cubit = context.read<CategoriesCubit>();
    final isAtRoot = cubit.isAtRootLevel;

    return Center(
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(
                ResponsiveUtils.getResponsiveSpacing(context, 20.0),
              ),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.getResponsiveBorderRadius(context, 16.0),
                ),
              ),
              child: Icon(
                Icons.category_outlined,
                size: ResponsiveUtils.getResponsiveIconSize(context, 64.0),
                color: Colors.grey[400],
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 16.0),
            ),
            Text(
              isAtRoot ? 'No categories found' : 'No subcategories found',
              style: TextStyle(
                fontSize: 18.0 * ResponsiveUtils.getFontSizeMultiplier(context),
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 8.0),
            ),
            Text(
              isAtRoot
                  ? 'Categories will appear here once they are added'
                  : 'This category has no subcategories',
              style: TextStyle(
                fontSize: 14.0 * ResponsiveUtils.getFontSizeMultiplier(context),
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    List<dynamic> categories,
    bool isLoadingMore,
    bool hasMore,
    bool isAdmin,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: ResponsiveUtils.getResponsivePadding(context).copyWith(
              top: ResponsiveUtils.getResponsiveSpacing(context, 16),
              bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
            ),
            itemCount: categories.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < categories.length) {
                final category = categories[index];
                return HierarchicalCategoryCard(
                  category: category,
                  index: index,
                  isAdmin: isAdmin,
                );
              } else {
                return Padding(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.getResponsiveSpacing(context, 16.0),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ),
        if (isLoadingMore)
          Container(
            padding: EdgeInsets.all(
              ResponsiveUtils.getResponsiveSpacing(context, 16.0),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8A95)),
              strokeWidth: 2,
            ),
          ),
      ],
    );
  }
}
