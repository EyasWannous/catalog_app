import 'package:catalog_app/core/network/service_locator.dart';
import 'package:catalog_app/core/route/app_routes.dart';
import 'package:catalog_app/features/categroy/presentation/cubit/categories_cubit.dart';
import 'package:catalog_app/features/categroy/presentation/screen/categories_screen.dart';
import 'package:catalog_app/features/homepage/presentation/screen/home_page.dart';
import 'package:catalog_app/features/products/presentation/bloc/products_cubit.dart';
import 'package:catalog_app/features/products/presentation/screen/products_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => sl<CategoriesCubit>()..getCategories(),
          child: HomePage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.category,
      builder: (context, state) {
        return CategoriesScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.product,
      builder: (context, state) {
        final extra = state.extra;
        String? categoryId;
        String? categoryName;
        if (extra is Map) {
          categoryId = extra['categoryId'] as String?;
          categoryName = extra['categoryName'] as String?;
        }
        return BlocProvider(
          create: (context) => sl<ProductsCubit>()..getProducts(categoryId ?? ''),
          child: ProductsScreen(categoryTitle: categoryName),
        );
      },
    ),
  ],
);
