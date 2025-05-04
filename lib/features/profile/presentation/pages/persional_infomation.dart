import 'package:flutter/material.dart';
import 'package:nu365/features/profile/models/goals.dart';

class PersionalInfomation extends StatelessWidget {
  final String userName;
  final String uId;
  final String dayOfbirth;
  final Goals goals;
  const PersionalInfomation(
      {super.key,
      required this.userName,
      required this.uId,
      required this.dayOfbirth,
      required this.goals});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          // Add your personal information widgets here
        ],
      ),
    );
  }
}
