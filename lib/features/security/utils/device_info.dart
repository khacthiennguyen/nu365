import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Trả về ID thiết bị duy nhất (per platform)
  static Future<String?> getDeviceId() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        return webInfo.vendor ?? webInfo.userAgent ?? "unknown-web";
      }

      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.id; // unique device ID
      }

      if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor; // unique device ID
      }

      return "unknown-device";
    } catch (e) {
      return "unknown-device";
    }
  }

  /// Trả về model thiết bị (ví dụ: "iPhone12,3" hoặc "Pixel 6")
  static Future<String?> getDeviceModel() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        return webInfo.userAgent;
      }

      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.model;
      }

      if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.utsname.machine;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Trả về tên hệ điều hành
  static Future<String?> getPlatformName() async {
    if (kIsWeb) return "Web";
    if (Platform.isAndroid) return "Android";
    if (Platform.isIOS) return "iOS";
    return "Unknown";
  }
}
