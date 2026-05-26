import 'package:dio/dio.dart';

import '../models/academic_summary.dart';
import '../models/student_profile.dart';
import '../services/api_client.dart';

class StudentRepository {
  StudentRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<StudentProfile> getMe() async {
    try {
      final response = await _apiClient.dio.get('/students/me');
      return StudentProfile.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e, 'Erro ao carregar perfil');
    }
  }

  Future<AcademicSummary> getSummary() async {
    try {
      final response = await _apiClient.dio.get('/students/me/summary');
      return AcademicSummary.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e, 'Erro ao carregar resumo');
    }
  }

  Exception _mapError(DioException e, String fallback) {
    final message = e.response?.data is Map
        ? (e.response?.data as Map)['message'] as String?
        : null;
    return Exception(message ?? fallback);
  }
}
