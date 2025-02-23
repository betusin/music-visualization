import 'package:flutter/material.dart';
import 'package:vibration_poc/common/app_root.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';

void main() {
  IocContainer.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppRoot();
  }
}
