import 'package:dio/dio.dart';

import '../models/schedule_event_item.dart';
import '../services/api_client.dart';

class ScheduleRepository {
  ScheduleRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ScheduleEventItem>> getByDate(DateTime date) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    try {
      final response = await _apiClient.dio.get(
        '/schedule',
        queryParameters: {'date': dateStr},
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => ScheduleEventItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data as Map)['message'] as String?
          : null;
      throw Exception(message ?? 'Erro ao carregar agenda');
    }
  }
}
