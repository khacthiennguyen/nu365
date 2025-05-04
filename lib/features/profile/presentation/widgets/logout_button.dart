import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/data/local/data_local.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          SQLite.deleteSession();
          RuntimeMemoryStorage.clear();
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
