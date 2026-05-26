import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_header.dart';
import 'app_navbar.dart';

class MainLayout extends StatelessWidget {
  final Widget body;
  final int currentNavIndex;
  final ValueChanged<int> onNavTap;
  final String userName;
  final String semesterInfo;
  final String avatarInitials;
  final bool showHeader;
  final VoidCallback? onProfileTap;

  const MainLayout({
    super.key,
    required this.body,
    required this.currentNavIndex,
    required this.onNavTap,
    this.userName = 'Natalia',
    this.semesterInfo = '1º SEMESTRE • 2026',
    this.avatarInitials = 'NA',
    this.showHeader = true,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: Column(
        children: [
          if (showHeader)
            AppHeader(
              userName: userName,
              semesterInfo: semesterInfo,
              avatarInitials: avatarInitials,
              onProfileTap: onProfileTap,
            ),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: AppNavbar(
        currentIndex: currentNavIndex,
        onTap: onNavTap,
      ),
    );
  }
}
