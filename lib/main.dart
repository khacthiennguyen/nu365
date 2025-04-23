import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nu365/core/api/utils/my_http_overrides.dart';
import 'package:nu365/platform_material.dart';
import 'package:nu365/setup_service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverride();
  setupServiceLocator();
  runApp(const Nu365());
}

class Nu365 extends StatelessWidget {
  const Nu365({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlatformMaterial();
  }
}
