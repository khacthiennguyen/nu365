import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/constants/app_theme.dart';
import 'package:nu365/core/constants/spacing.dart';
import 'package:nu365/features/manage_main_layout/presentation/widgets/main_layout_app_bar.dart';
import 'package:nu365/features/manage_main_layout/presentation/widgets/main_layout_bottom_navigation.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key, 
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Determine current index based on the current route
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    
    if (location.startsWith('/dashboard')) {
      currentIndex = 0;
    } else if (location.startsWith('/scan')) {
      currentIndex = 1;
    } else if (location.startsWith('/history')) {
      currentIndex = 2;
    } else if (location.startsWith('/profile')) {
      currentIndex = 3;
    }

    return Scaffold(
      body: Container(
        color: AppTheme.backgroundLight,
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.padding_20, vertical: Spacing.padding_12),
        child: Column(
          children: [
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: MainLayoutBottomNavigation(
        currentIndex: currentIndex,
      ),
    );
  }
}
