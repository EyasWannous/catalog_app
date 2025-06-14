import 'package:catalog_app/core/config/app_config.dart';
import 'package:catalog_app/core/constants/app_strings.dart';
import 'package:catalog_app/core/network/service_locator.dart';
import 'package:catalog_app/core/route/app_routes.dart';
import 'package:catalog_app/features/categroy/presentation/screen/paginated_categories_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/sharedWidgets/custom_app_bar.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use global admin configuration
    final isAdmin = AppConfig.isAdmin;

    return BlocProvider(
      create: (context) =>
          sl<CategoriesCubit>()..getCategories(isInitialLoad: true),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: AppStrings.categoriesTitle.tr(),
          onMenuPressed: () {},
          onSearchChanged: (value) {},
          // Add admin action to app bar if needed
        ),
        floatingActionButton: isAdmin
            ? Builder(
                builder: (context) => FloatingActionButton(
                  onPressed: () async {
                    await context
                        .push(AppRoutes.categoryForm, extra: {'category': null})
                        .then((_) {
                          // This runs when returning to CategoriesScreen
                          if (context.mounted) {
                            context.read<CategoriesCubit>().getCategories(
                              isInitialLoad: true,
                            );
                          }
                        });
                  },
                  child: const Icon(Icons.add),
                ),
              )
            : null,
        body: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoriesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CategoriesCubit>().getCategories(
                          isInitialLoad: true,
                        );
                      },
                      child: Text(AppStrings.retry.tr()),
                    ),
                  ],
                ),
              );
            }

            if (state is CategoriesLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: PaginatedCategoriesList(
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
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
