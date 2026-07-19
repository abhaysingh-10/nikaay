import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/chat_message.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final List<String> suggestions;

  const ChatState({
    required this.messages,
    this.isTyping = false,
    required this.suggestions,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    List<String>? suggestions,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  @override
  ChatState build() {
    return const ChatState(
      isTyping: true,
      suggestions: [
        'Best serum for acne',
        'How to reduce oiliness?',
        'Skincare routine',
      ],
      messages: [
        ChatMessage(
          id: '1',
          text:
              "Hello, Ananya! 👋\nI'm here to help you with your skincare questions. What would you like to know?",
          sender: MessageSender.assistant,
          timestamp: '9:41 AM',
        ),
        ChatMessage(
          id: '2',
          text: 'What cleanser should I use for acne prone skin?',
          sender: MessageSender.user,
          timestamp: '9:42 AM',
          status: MessageStatus.delivered,
        ),
        ChatMessage(
          id: '3',
          text:
              'For acne prone skin, look for a gentle cleanser with these ingredients:',
          sender: MessageSender.assistant,
          timestamp: '9:43 AM',
          bulletPoints: [
            BulletItem(
              title: 'Salicylic Acid',
              description: 'Unclogs pores',
            ),
            BulletItem(
              title: 'Tea Tree Oil',
              description: 'Fights acne bacteria',
            ),
            BulletItem(
              title: 'Niacinamide',
              description: 'Reduces inflammation',
            ),
            BulletItem(
              title: 'Aloe Vera',
              description: 'Soothes the skin',
            ),
          ],
          footerText:
              'I can recommend some great organic cleanser options for you.',
        ),
      ],
    );
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final now = DateTime.now();
    final timeStr =
        "${now.hour % 12 == 0 ? 12 : now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      sender: MessageSender.user,
      timestamp: timeStr,
      status: MessageStatus.delivered,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
    );

    // Simulate AI response for mock mode
    Future.delayed(const Duration(seconds: 2), () {
      final aiMsg = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text:
            "Thanks for asking! Based on your skin profile, I recommend testing gentle organic formulations first.",
        sender: MessageSender.assistant,
        timestamp: timeStr,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMsg],
        isTyping: false,
      );
    });
  }

  void selectSuggestion(String suggestion) {
    sendMessage(suggestion);
  }
}

final chatProvider =
    NotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);
