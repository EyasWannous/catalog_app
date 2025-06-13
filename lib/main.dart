import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/network/service_locator.dart';
import 'core/route/app_router.dart';
import 'features/categroy/data/models/category_model.dart';
import 'features/products/data/model/product_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryModelAdapter());
  await Hive.openBox<CategoryModel>('categoriesBox');

  Hive.registerAdapter(ProductModelAdapter());
  await Hive.openBox('productsBox');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  await init();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Catalog App',
      useInheritedMediaQuery: true, // Required for device_preview
      locale: DevicePreview.locale(context), // Required for device_preview
      builder: DevicePreview.appBuilder, // Required for device_preview
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFFC1D4)),
        useMaterial3: true,
      ),
    );
  }
}
