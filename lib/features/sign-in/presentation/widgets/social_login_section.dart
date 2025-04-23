import 'package:flutter/material.dart';
import 'package:nu365/core/constants/app_theme.dart';
import 'package:nu365/core/constants/images.dart';
import 'package:nu365/features/sign-in/presentation/widgets/social_bution.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;

  const SocialLoginSection({
    Key? key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _DividerWithText(text: 'Or continue with'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SocialButton(
                icon: Images.google_logo,
                label: 'Google',
                onPressed: onGooglePressed,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SocialButton(
                icon: Images.facebook_logo,
                label: 'Facebook',
                onPressed: onFacebookPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DividerWithText extends StatelessWidget {
  final String text;

  const _DividerWithText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}