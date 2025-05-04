import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/pages/home.dart';
import 'package:nu365/features/dashboard/presentation/pages/dashboard.dart';
import 'package:nu365/features/history/presention/pages/history_screen.dart';
import 'package:nu365/features/manage_main_layout/presentation/pages/main_layout.dart';
import 'package:nu365/features/profile/presentation/pages/persional_infomation.dart';
import 'package:nu365/features/profile/presentation/pages/profile_screen.dart';
import 'package:nu365/features/scan/presentation/pages/scan_screen_wrapper.dart';
import 'package:nu365/features/auth/presentation/pages/login_screen.dart';

GoRouter appRoutes = GoRouter(
    initialLocation: '/',
    navigatorKey: GlobalKey<NavigatorState>(),
    routes: [
      GoRoute(path: "/", builder: (context, state) => const StartUpPage()),
      GoRoute(
          path: '/sign-in', builder: (context, state) => const LoginScreen()),
      ShellRoute(
          builder: (context, state, child) => MainLayout(child: child),
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: '/scan',
              builder: (context, state) => const ScanScreenWrapper(),
            ),
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfileScreen(),
            ),
            GoRoute(
              path: '/personal-info',
              builder: (context, state) => PersionalInfomation(),
            ),
          ])
    ]);
