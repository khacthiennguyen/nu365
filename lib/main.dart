import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nu365/core/api/utils/my_http_overrides.dart';
import 'package:nu365/core/data/local/data_local.dart';
import 'package:nu365/core/data/local/secure_storage_initializer.dart';
import 'package:nu365/core/data/supabase/supabase_data.dart';
import 'package:nu365/platform_material.dart';
import 'package:nu365/setup_service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverride();
  await dotenv.load(fileName: ".env");
  await SQLite.setupDatabase();
  await SupabaseData.initialize();

  // Khởi tạo Secure Storage trước
  await SecureStorageInitializer.initialize();

  // Initialize Service Locator
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
