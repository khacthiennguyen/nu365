import 'package:flutter/material.dart';
import 'package:nu365/core/constants/app_theme.dart';

class ProfileInformation extends StatelessWidget {
  final String userName;
  final String uId;
  final String ? avatarUrl;
  const ProfileInformation(
      {super.key, required this.userName, required this.uId, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: avatarUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(avatarUrl!),
                        radius: 46,
                      )
                    : Text(
                        'AVTAR',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
           Text(
            uId,
            style: TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
