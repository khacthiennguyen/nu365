import 'package:flutter/material.dart';

class SettingsSwitches extends StatelessWidget {
  final String title;
  final String? description;
  final bool currentValue;
  final Function(bool) onChanged;
  const SettingsSwitches(
      {super.key,
      required this.title,
      required this.description,
      required this.onChanged,
      required this.currentValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 212, 212, 212),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title),
        value: currentValue,
        onChanged: onChanged,
      ),
    );
  }
}
