import 'package:flutter/foundation.dart';

import '../models/student_profile.dart';

class SessionProvider extends ChangeNotifier {
  StudentProfile? _student;

  StudentProfile? get student => _student;

  bool get isLoggedIn => _student != null;

  void setStudent(StudentProfile student) {
    _student = student;
    notifyListeners();
  }

  void clear() {
    _student = null;
    notifyListeners();
  }
}
