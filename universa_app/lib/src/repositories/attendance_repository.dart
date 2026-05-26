import 'package:dio/dio.dart';

import '../models/attendance_item.dart';
import '../services/api_client.dart';

class AttendanceRepository {
  AttendanceRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<AttendanceItem>> getAttendance() async {
    try {
      final response = await _apiClient.dio.get('/attendance');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => AttendanceItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data as Map)['message'] as String?
          : null;
      throw Exception(message ?? 'Erro ao carregar frequencia');
    }
  }
}
