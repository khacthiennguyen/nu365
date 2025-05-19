import 'package:flutter/material.dart';
import 'package:nu365/core/constants/app_theme.dart';

class SettingsSwitches extends StatelessWidget {
  final String title;
  final String? description;
  final bool currentValue;
  final Function(bool)? onChanged;
  final Widget? trailing;

  const SettingsSwitches({
    super.key,
    required this.title,
    this.description,
    required this.onChanged,
    required this.currentValue,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: description != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              )
            : null,
        trailing: trailing ??
            Switch(
              value: currentValue,
              onChanged: onChanged,
              activeColor: AppTheme.primaryPurple,
            ),
      ),
    );
  }
}
