import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AssessmentRepository(dio);
});

class AssessmentRepository {
  final Dio _dio;

  AssessmentRepository(this._dio);

  Future<Map<String, dynamic>> submitAssessment(
      Map<String, String> answers) async {
    try {
      final response = await _dio.post(
        'assessments/submit/',
        data: answers,
      );
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> fetchAssessmentHistory() async {
    try {
      final response = await _dio.get('assessments/submit/');
      return List<dynamic>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
