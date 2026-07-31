import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/assessment_repository.dart';

final assessmentHistoryProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final repository = ref.watch(assessmentRepositoryProvider);
  return repository.fetchAssessmentHistory();
});
