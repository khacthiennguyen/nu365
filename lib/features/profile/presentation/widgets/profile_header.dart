import 'package:flutter/material.dart';
import 'package:nu365/core/constants/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userId;
  final String createdAt;
  final TextEditingController? userNameController;
  final bool isEditMode;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userId,
    required this.createdAt,
    this.userNameController,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primaryPurple.withOpacity(0.2),
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            ),
          ),
          const SizedBox(height: 16),
          isEditMode && userNameController != null
              ? TextField(
                  controller: userNameController!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Tên người dùng',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                )
              : Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: 8),
          Text(
            userId,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Thành viên từ $createdAt',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
