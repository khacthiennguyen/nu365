import 'package:flutter/material.dart';
import 'package:nu365/core/constants/colors.dart';
import 'package:nu365/core/constants/spacing.dart';


class AuthenticationLayout extends StatefulWidget {
  final Widget child;

  const AuthenticationLayout({super.key, required this.child});

  @override
  State<AuthenticationLayout> createState() => _AuthenticationLayoutState();
}

class _AuthenticationLayoutState extends State<AuthenticationLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          color: AppColor.authentication_theme_color
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.padding_25, vertical: Spacing.padding_12),
        child: widget.child,
      ),
    );
  }
}
