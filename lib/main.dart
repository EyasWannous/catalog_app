import 'package:catalog_app/core/network/service_locator.dart';
import 'package:catalog_app/core/route/app_router.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/constants/app_strings.dart';
import 'features/categroy/data/models/category_model.dart';
import 'features/products/data/model/product_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryModelAdapter()); // Required for Hive
  await Hive.openBox<CategoryModel>('categoriesBox');

  Hive.registerAdapter(ProductModelAdapter());
  await Hive.openBox('productsBox'); // Open the box without specifying the type
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  await init();

  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: AppStrings.appTitle,

      locale: DevicePreview.locale(context),
      // Required for device_preview
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFFC1D4)),
        useMaterial3: true,
      ),
    );
  }
}


