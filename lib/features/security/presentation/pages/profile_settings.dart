import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/features/security/presentation/widgets/settings_cart.dart';
import 'package:nu365/features/security/presentation/widgets/settings_swtiches.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cài đặt tài khoản",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SettingsCard(
                  title: 'Bảo mật tài khoản',
                  widgets: [
                    ListTile(
                      title: const Text("Xác thực 2 yếu tố"),
                      subtitle: const Text("Đang bật"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.push('/two-factor-settings');
                      },
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: const Text("Xác thực sinh trắc học"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      subtitle: const Text("Đang bật"),
                      onTap: () {
                        context.push('/biometric-settings');
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
