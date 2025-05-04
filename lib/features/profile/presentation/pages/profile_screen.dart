import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/constants/app_theme.dart';
import 'package:nu365/core/data/local/data_local.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/features/profile/presentation/pages/persional_infomation.dart';
import 'package:nu365/features/profile/presentation/widgets/logout_button.dart';
import 'package:nu365/features/profile/presentation/widgets/profile_infomation.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final info = RuntimeMemoryStorage.get('session');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Info
          ProfileInformation(
            userName: info['username'] ?? "",
            uId: info['uId'] ?? "",
          ),
          const SizedBox(height: 32),
          // Profile menu items
          Card(
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Thông tin cá nhân',
                  onTap: () {
                    context.push('/personal-info');
                  },
                ),
                const Divider(),
                // _buildMenuItem(
                //   icon: Icons.fitness_center_outlined,
                //   title: 'Goals',
                //   onTap: () {},
                // ),
                // const Divider(),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Cài đặt',
                  onTap: () {},
                ),
                // const Divider(),
                // _buildMenuItem(
                //   icon: Icons.help_outline,
                //   title: 'Help & Support',
                //   onTap: () {},
                // ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          // Logout button
          LogoutButton(),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryPurple),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
