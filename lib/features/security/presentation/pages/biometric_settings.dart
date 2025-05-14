import 'package:flutter/material.dart';
import 'package:nu365/features/security/presentation/widgets/settings_cart.dart';
import 'package:nu365/features/security/presentation/widgets/settings_swtiches.dart';

class BiometricSettings extends StatelessWidget {
  final bool biometricEnabled;
  const BiometricSettings({super.key, required this.biometricEnabled});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác thực sinh trắc học",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SettingsCard(
        widgets: [
          SettingsSwitches(
            title: 'Xác thực sinh trắc học',
            description: biometricEnabled ? 'Bật' : 'Tắt',
            onChanged: (value) {},
            currentValue: biometricEnabled,
          )
        ],
      ),
    );
  }
}
