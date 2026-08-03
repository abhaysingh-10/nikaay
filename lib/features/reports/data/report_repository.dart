import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../domain/report.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  return ReportRepository(dio);
});

class ReportRepository {
  final Dio _dio;

  ReportRepository(this._dio);

  Future<List<Report>> fetchReports() async {
    try {
      final response = await _dio.get('reports/upload/');
      final data = response.data as List<dynamic>;
      return data.map((json) => Report.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Report> uploadReport({
    required File file,
    required void Function(int sent, int total) onProgress,
  }) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        'reports/upload/',
        data: formData,
        onSendProgress: onProgress,
      );

      return Report.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
