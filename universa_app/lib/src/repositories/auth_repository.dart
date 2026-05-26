import 'package:dio/dio.dart';

import '../models/student_profile.dart';
import '../services/api_client.dart';
import '../services/token_storage.dart';

class AuthRepository {
  AuthRepository(this._apiClient, this._tokenStorage);

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  Future<StudentProfile> login(String login, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {'login': login, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      await _tokenStorage.saveToken(token);

      final studentJson = data['student'] as Map<String, dynamic>;
      return StudentProfile.fromJson(studentJson);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data as Map)['message'] as String?
          : null;
      throw Exception(
        message ?? 'Falha ao entrar. Verifique a conexao com a API.',
      );
    }
  }

  Future<void> logout() => _tokenStorage.clearToken();
}
