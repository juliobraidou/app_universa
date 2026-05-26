import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/session_provider.dart';
import '../repositories/auth_repository.dart';
import '../repositories/student_repository.dart';
import '../services/token_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final token = await context.read<TokenStorage>().readToken();
    if (!mounted) return;

    if (token == null || token.isEmpty) {
      _go('/login');
      return;
    }

    try {
      final profile = await context.read<StudentRepository>().getMe();
      if (!mounted) return;
      context.read<SessionProvider>().setStudent(profile);
      _go('/dash');
    } catch (_) {
      await context.read<AuthRepository>().logout();
      if (!mounted) return;
      context.read<SessionProvider>().clear();
      _go('/login');
    }
  }

  void _go(String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
