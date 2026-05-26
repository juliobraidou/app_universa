import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/session_provider.dart';
import 'repositories/attendance_repository.dart';
import 'repositories/auth_repository.dart';
import 'repositories/grades_repository.dart';
import 'repositories/schedule_repository.dart';
import 'repositories/student_repository.dart';
import 'routing/app_router.dart';
import 'services/api_client.dart';
import 'services/token_storage.dart';
import 'viewmodels/login_view_model.dart';

class AppUniversa extends StatelessWidget {
  const AppUniversa({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => TokenStorage()),
        ProxyProvider<TokenStorage, ApiClient>(
          update: (_, storage, previous) => ApiClient(storage),
        ),
        ProxyProvider2<ApiClient, TokenStorage, AuthRepository>(
          update: (_, client, storage, previous) =>
              AuthRepository(client, storage),
        ),
        ProxyProvider<ApiClient, StudentRepository>(
          update: (_, client, previous) => StudentRepository(client),
        ),
        ProxyProvider<ApiClient, GradesRepository>(
          update: (_, client, previous) => GradesRepository(client),
        ),
        ProxyProvider<ApiClient, AttendanceRepository>(
          update: (_, client, previous) => AttendanceRepository(client),
        ),
        ProxyProvider<ApiClient, ScheduleRepository>(
          update: (_, client, previous) => ScheduleRepository(client),
        ),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProxyProvider2<AuthRepository, SessionProvider,
            LoginViewModel>(
          create: (context) => LoginViewModel(
            context.read<AuthRepository>(),
            context.read<SessionProvider>(),
          ),
          update: (_, auth, session, previous) =>
              previous ?? LoginViewModel(auth, session),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Universa',
        initialRoute: '/',
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
