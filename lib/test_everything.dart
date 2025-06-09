import 'package:flutter/material.dart';
import 'package:catalog_app/core/utils/app_logger.dart';

import 'di/injection_container.dart';

class TestEverything extends StatefulWidget {
  TestEverything({super.key}) : _logger = sl<AppLogger>();

  final AppLogger _logger;

  @override
  State<TestEverything> createState() => _TestEverythingState();
}

class _TestEverythingState extends State<TestEverything> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(onPressed: onPressed, child: const Text('Press To Test'))
        ],
      ),
    );
  }

  void onPressed() {
    widget._logger.info("Text Button in TestEverything has been pressed");
    try {
      //TODO
    } on Exception catch (error, stacktrace) {
      widget._logger.error(error.toString(), error, stacktrace);
    }
  }
}