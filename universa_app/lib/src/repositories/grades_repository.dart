import 'package:dio/dio.dart';

import '../models/grade_item.dart';
import '../services/api_client.dart';

class GradesRepository {
  GradesRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<GradeItem>> getGrades() async {
    try {
      final response = await _apiClient.dio.get('/grades');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => GradeItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data as Map)['message'] as String?
          : null;
      throw Exception(message ?? 'Erro ao carregar notas');
    }
  }
}
