import 'package:flutter/material.dart';
import 'package:nu365/core/constants/colors.dart';
import 'package:nu365/core/constants/sizes.dart';
import 'package:nu365/core/constants/spacing.dart';
import 'package:nu365/core/widgets/app_text.dart';

showNotificationDialog(BuildContext context,
    {required String notificationContent}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.authentication_theme_color,
          title: Row(
            children: <Widget>[
              const Icon(
                Icons.warning_rounded,
                color: AppColor.yellow,
              ),
              Spacing.width10,
              AppText(
                content: 'Thông báo',
                textSize: Sizes.font_size_title,
              )
            ],
          ),
          content: AppText(content: notificationContent),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.authentication_button_color,
                  shadowColor: AppColor.authentication_button_color,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: AppText(content: 'OK')),
          ],
        );
      });
}

showErrorDialog(BuildContext context,
    {required String notificationContent}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.authentication_theme_color,
          title: Row(
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                color: AppColor.red,
              ),
              Spacing.width10,
              AppText(
                content: 'Lỗi',
                textSize: Sizes.font_size_title,
              )
            ],
          ),
          content: AppText(content: notificationContent),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.authentication_button_color,
                  shadowColor: AppColor.authentication_button_color,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: AppText(content: 'OK')),
          ],
        );
      });
}
