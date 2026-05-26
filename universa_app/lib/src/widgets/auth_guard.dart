import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/session_provider.dart';
import '../repositories/auth_repository.dart';
import '../repositories/student_repository.dart';
import '../services/token_storage.dart';

/// Bloqueia rotas privadas sem token/sessao valida.
class AuthGuard extends StatefulWidget {
  const AuthGuard({super.key, required this.child});

  final Widget child;

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool? _allowed;

  @override
  void initState() {
    super.initState();
    _verify();
  }

  Future<void> _verify() async {
    final token = await context.read<TokenStorage>().readToken();
    if (!mounted) return;

    if (token == null || token.isEmpty) {
      setState(() => _allowed = false);
      return;
    }

    if (context.read<SessionProvider>().isLoggedIn) {
      setState(() => _allowed = true);
      return;
    }

    try {
      final profile = await context.read<StudentRepository>().getMe();
      if (!mounted) return;
      context.read<SessionProvider>().setStudent(profile);
      setState(() => _allowed = true);
    } catch (_) {
      await context.read<AuthRepository>().logout();
      if (!mounted) return;
      context.read<SessionProvider>().clear();
      setState(() => _allowed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_allowed == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_allowed == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
      });
      return const SizedBox.shrink();
    }

    return widget.child;
  }
}
