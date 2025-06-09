import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:catalog_app/core/network/network_info.dart';
import 'package:catalog_app/core/utils/app_logger.dart';
import 'package:catalog_app/data/datasources/remote/remote_user_datasource.dart';
import 'package:catalog_app/data/repositories_impl/user_repository_impl.dart';
import 'package:catalog_app/domain/repositories/user_repository.dart';

final GetIt sl = GetIt.instance; // sl stands for Service Locator

Future<void> initDependencies() async {

  sl.registerLazySingleton<AppLogger>(() => AppLogger());
  
  sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(baseUrl: 'https://api.yourdomain.com'))); //TODO
  
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectivity: sl()));

  sl.registerLazySingletonAsync<SharedPreferences>(() async => await SharedPreferences.getInstance());
  sl.registerLazySingleton<RemoteUserDataSource>(() => RemoteUserDataSourceImpl(dio: sl()));
  
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
    )
  );
}
