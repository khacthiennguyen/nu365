import 'package:flutter/material.dart';
import 'package:nu365/core/constants/app_theme.dart';

class SettingsCard extends StatelessWidget {
  final String? title;
  final List<Widget> widgets;
  const SettingsCard({super.key, required this.widgets, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 12.0, top: 4.0),
              child: Text(
                title ?? '',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textPrimary),
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          )
        ],
      ),
    );
  }
}
