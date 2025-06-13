import 'package:catalog_app/features/products/data/datasource/product_local_data_source.dart';
import 'package:catalog_app/features/products/data/datasource/product_remote_data_source.dart';
import 'package:catalog_app/features/products/data/repository/product_repo_impl.dart';
import 'package:catalog_app/features/products/domain/repository/product_repository.dart';
import 'package:catalog_app/features/products/domain/usecase/get_product_use_case.dart';
import 'package:catalog_app/features/products/presentation/cubit/productcubit/product_cubit.dart';
import 'package:catalog_app/features/products/presentation/cubit/products_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:catalog_app/features/categroy/data/datasources/local/category_local_data_source.dart';
import 'package:catalog_app/features/categroy/data/models/category_model.dart';
import 'package:catalog_app/core/network/api_service.dart';
import 'package:catalog_app/core/network/network_info.dart';
import 'package:catalog_app/features/categroy/data/datasources/remote/category_remote_data_source.dart';
import 'package:catalog_app/features/categroy/data/repositories/category_repository_impl.dart';
import 'package:catalog_app/features/categroy/domain/repositories/category_repository.dart';
import 'package:catalog_app/features/categroy/domain/usecases/get_categories.dart';
import 'package:catalog_app/features/categroy/presentation/cubit/categories_cubit.dart';

/// Service Locator for dependency injection
/// Uses GetIt package for managing dependencies
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
/// Call this method in main() before running the app
Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Core dependencies
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton<ApiService>(() => ApiService(networkInfo: sl()));

  // Features - Category
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl()),
  );
  // Register the box
  sl.registerLazySingleton<Box<CategoryModel>>(
    () => Hive.box<CategoryModel>('categoriesBox'),
  );
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(sl<Box<CategoryModel>>()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(() => GetCategoriesUseCase(sl()));
  sl.registerFactory<CategoriesCubit>(() => CategoriesCubit(sl()));

  // Features - Product
  sl.registerLazySingleton<Box>(() => Hive.box('productsBox'));
  // sl.registerLazySingleton<Box<ProductModel>>(() => Hive.box<ProductModel>('productsBox'));
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepoImpl(
      productRemoteDataSource: sl(),
      productLocalDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(sl()));
  sl.registerFactory<ProductsCubit>(() => ProductsCubit(sl()));
  sl.registerFactory<ProductCubit>(() => ProductCubit());
}

/// Convenience getters for commonly used services
ApiService get apiService => sl<ApiService>();

NetworkInfo get networkInfo => sl<NetworkInfo>();
