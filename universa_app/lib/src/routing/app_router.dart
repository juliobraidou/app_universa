import 'package:flutter/material.dart';

import '../pages/home_shell_page.dart';
import '../pages/login_page.dart';
import '../pages/splash_page.dart';
import '../widgets/auth_guard.dart';

abstract final class AppRouter {
  static const publicRoutes = {'/', '/login'};

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '/';

    switch (name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/dash':
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: HomeShellPage()),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
    }
  }
}
