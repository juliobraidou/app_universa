import 'package:flutter/foundation.dart';

import '../models/student_profile.dart';
import '../repositories/auth_repository.dart';
import '../providers/session_provider.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this._authRepository, this._sessionProvider);

  final AuthRepository _authRepository;
  final SessionProvider _sessionProvider;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<StudentProfile?> login(String login, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final student = await _authRepository.login(login.trim(), password);
      _sessionProvider.setStudent(student);
      return student;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
