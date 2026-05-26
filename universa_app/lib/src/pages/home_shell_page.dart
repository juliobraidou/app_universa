import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/session_provider.dart';
import '../repositories/auth_repository.dart';
import '../widgets/logout_confirm_dialog.dart';
import '../widgets/main_layout.dart';
import '../widgets/profile_menu_sheet.dart';
import 'agenda_page.dart';
import 'dash_central_page.dart';
import 'notas_page.dart';
import 'carteirinha_page.dart';

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  int _navIndex = 0;

  void _openProfileMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => ProfileMenuSheet(
        onLogout: () {
          Navigator.pop(sheetContext);
          _showLogoutConfirm(context);
        },
      ),
    );
  }

  void _showLogoutConfirm(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => LogoutConfirmDialog(
        onConfirm: () async {
          final authRepo = context.read<AuthRepository>();
          final session = context.read<SessionProvider>();
          final navigator = Navigator.of(context);
          await authRepo.logout();
          session.clear();
          if (!dialogContext.mounted) return;
          Navigator.pop(dialogContext);
          navigator.pushReplacementNamed('/login');
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  Widget _buildBody() {
    return switch (_navIndex) {
      0 => const DashCentralContent(),
      1 => const NotasPage(),
      2 => const AgendaPage(),
      3 => const CarteirinhaPage(),
      _ => const DashCentralContent(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();
    final student = session.student;

    return MainLayout(
      showHeader: _navIndex == 0,
      currentNavIndex: _navIndex,
      userName: student?.firstName ?? 'Aluno',
      semesterInfo: student?.semesterLabel ?? '',
      avatarInitials: student?.avatarInitials ?? 'UN',
      onNavTap: (index) => setState(() => _navIndex = index),
      onProfileTap: _navIndex == 0 ? () => _openProfileMenu(context) : null,
      body: _buildBody(),
    );
  }
}
