import 'package:flutter/material.dart';
import 'package:vibration_poc/common/app_root.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';

void main() {
  IocContainer.setup();
  runApp(const AppRoot());
}
