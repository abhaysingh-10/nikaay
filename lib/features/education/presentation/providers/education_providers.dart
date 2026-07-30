import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/article.dart';
import '../../data/mock_articles.dart';

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() {
    return 'All';
  }

  void select(String category) {
    state = category;
  }
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(SelectedCategoryNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void updateQuery(String query) {
    state = query;
  }
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

final filteredArticlesProvider = Provider<List<Article>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final search = ref.watch(searchQueryProvider).toLowerCase().trim();

  return mockArticles.where((article) {
    final matchesCategory = category == 'All' || article.category == category;
    final matchesSearch = search.isEmpty ||
        article.title.toLowerCase().contains(search) ||
        article.subtitle.toLowerCase().contains(search) ||
        article.content.toLowerCase().contains(search);
    return matchesCategory && matchesSearch;
  }).toList();
});
