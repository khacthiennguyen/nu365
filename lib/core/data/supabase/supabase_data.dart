import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseData {
  static Future<void> initialize() async {
    final x = dotenv.env['DB_SECRET_KEY'];
    await Supabase.initialize(
      url: 'https://wyufiwnjblmrkxxjqupg.supabase.co',
      anonKey: x!,
    );
  }
}
