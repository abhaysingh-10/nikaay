import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../providers/chat_provider.dart';

class SuggestionChips extends ConsumerWidget {
  const SuggestionChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(chatProvider.select((state) => state.suggestions));

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ActionChip(
            elevation: 0,
            pressElevation: 0,
            backgroundColor: const Color(0xFFF6EFE5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(
                color: Color(0xFFEAE5D9),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            label: Text(
              suggestion,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              ref.read(chatProvider.notifier).selectSuggestion(suggestion);
            },
          );
        },
      ),
    );
  }
}
