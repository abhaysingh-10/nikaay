import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/report_repository.dart';
import '../domain/report.dart';

class UploadProgressNotifier extends Notifier<double> {
  @override
  double build() => 0.0;

  void update(double progress) {
    state = progress;
  }
}

final uploadProgressProvider = NotifierProvider<UploadProgressNotifier, double>(
    UploadProgressNotifier.new);

final reportsListProvider = FutureProvider<List<Report>>((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  return repository.fetchReports();
});

class ReportUploadNotifier extends AsyncNotifier<Report?> {
  @override
  FutureOr<Report?> build() => null;

  Future<void> uploadFile(File file) async {
    state = const AsyncValue.loading();
    ref.read(uploadProgressProvider.notifier).update(0.0);

    try {
      final repository = ref.read(reportRepositoryProvider);
      final report = await repository.uploadReport(
        file: file,
        onProgress: (sent, total) {
          if (total > 0) {
            ref.read(uploadProgressProvider.notifier).update(sent / total);
          }
        },
      );

      ref.invalidate(reportsListProvider);
      state = AsyncValue.data(report);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteReport(int id) async {
    try {
      final repository = ref.read(reportRepositoryProvider);
      await repository.deleteReport(id);
      ref.invalidate(reportsListProvider);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final reportUploadNotifierProvider =
    AsyncNotifierProvider<ReportUploadNotifier, Report?>(
  ReportUploadNotifier.new,
);
