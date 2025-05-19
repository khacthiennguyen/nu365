import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/data/local/data_local.dart';
import 'package:nu365/core/data/local/data_security.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          print("DEBUG: User clicked logout button");
          try {
            await SQLite.deleteSession();
            print("DEBUG: Session deleted from SQLite");

            // Clear biometric data from secure storage
            await DataSecurity().clearBiometricData();
            print("DEBUG: Biometric data cleared from secure storage");
          } catch (e) {
            print("DEBUG: Error during logout process: $e");
          }
          RuntimeMemoryStorage.clear();
          print("DEBUG: Memory storage cleared");
          context.go('/sign-in');
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Đăng xuất',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
