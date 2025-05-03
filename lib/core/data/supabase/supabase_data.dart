import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseData {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url:
          'https://wyufiwnjblmrkxxjqupg.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind5dWZpd25qYmxtcmt4eGpxdXBnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUzNDM1ODksImV4cCI6MjA2MDkxOTU4OX0.xlYotKn8keCT5px27TPA-nUDfh_hpV1e_8VvZQ5cU5M', 
    );
  }
}
