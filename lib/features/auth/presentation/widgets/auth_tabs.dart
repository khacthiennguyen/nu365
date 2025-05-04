import 'package:flutter/material.dart';
import 'package:nu365/core/constants/app_theme.dart';

class AuthTabs extends StatelessWidget {
  final TabController tabController;

  const AuthTabs({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    
      child: TabBar(
        controller: tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.transparent,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
         
        ),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        labelColor: AppTheme.primaryPurple,
        unselectedLabelColor: Colors.grey.shade600,
        tabs: const [
          Tab(text: 'Login'),
          Tab(text: 'Register'),
        ],
      ),
    );
  }
}
