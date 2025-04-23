import 'package:flutter/material.dart';

import 'package:nu365/core/widgets/app_text.dart';

class MainLayoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  // These are the properties that can be customized when using this app bar
  final String? title; // The title text to show in the app bar
  final Color? backgroundcolors; // Background color of the app bar
  final Widget?
      leading; // Widget to display before the title (usually a back button or menu icon)
  final Widget?
      action; // Widget to display on the right side of the app bar (actions like search, settings)
  final Widget? bottom; // Widget to display below the app bar (like a tab bar)

  // Constructor that allows setting these properties when creating the app bar
  const MainLayoutAppBar(
      {super.key,
      this.title,
      this.backgroundcolors,
      this.leading,
      this.action,
      this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundcolors ??
          Colors
              .transparent, // Use provided background color or default to transparent
      title: Text(title ??
          ''), // Use provided title or default to 'Hi,Khac Thien'
      leading: leading, // Use provided leading widget if any
      actions: action != null
          ? [action!]
          : null, // Add the action widget to actions list if provided
      bottom: bottom != null
          ? PreferredSize(
              // Add the bottom widget if provided
              preferredSize: const Size.fromHeight(48.0),
              child: bottom!,
            )
          : null,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Standard app bar height
}
