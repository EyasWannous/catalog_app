import 'package:catalog_app/core/network/service_locator.dart';
import 'package:catalog_app/core/route/app_routes.dart';
import 'package:catalog_app/features/categroy/presentation/screen/categories_screen.dart';
import 'package:catalog_app/features/products/presentation/cubit/productcubit/product_cubit.dart';
import 'package:catalog_app/features/products/presentation/cubit/products_cubit.dart';
import 'package:catalog_app/features/products/presentation/screen/product_screen.dart';
import 'package:catalog_app/features/products/presentation/screen/products_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        return const CategoriesScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.products,
      builder: (context, state) {
        final extra = state.extra;
        String? categoryId;
        String? categoryName;
        if (extra is Map) {
          categoryId = extra['categoryId'] as String?;
          categoryName = extra['categoryName'] as String?;
        }
        return BlocProvider(
          create:
              (context) =>
                  sl<ProductsCubit>()
                    ..getProducts(categoryId ?? '', isInitialLoad: true),
          child: ProductsScreen(categoryTitle: categoryName),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.product,
      builder: (context, state) {
        final extra = state.extra;
        int? productId;
        if (extra is Map) {
          productId = extra['productId'] as int?;
        }
        return BlocProvider(
          create: (context) => sl<ProductCubit>()..getProduct(productId ?? 1),
          child: ProductScreen(productId: productId ?? 1),
        );
      },
    ),
  ],
);
