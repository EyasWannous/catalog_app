import 'package:catalog_app/features/categroy/presentation/screen/categories_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'features/homepage/presentation/screen/home_page.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Enable only in debug mode
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catalog App',
      useInheritedMediaQuery: true, // Required for device_preview
      locale: DevicePreview.locale(context), // Required for device_preview
      builder: DevicePreview.appBuilder, // Required for device_preview
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFFC1D4)),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
