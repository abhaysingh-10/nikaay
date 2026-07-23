import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
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
      isTyping: false,
      suggestions: [
        'Best serum for acne',
        'How to reduce oiliness?',
        'Skincare routine',
      ],
      messages: [
        ChatMessage(
          id: '1',
          text:
              "Hello! \nI'm here to help you with your skincare questions. What would you like to know?",
          sender: MessageSender.assistant,
          timestamp: '9:41 AM',
        ),
      ],
    );
  }

  Future<void> sendMessage(String text) async {
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

    final historyPayload = state.messages
        .map((m) => {
              'sender': m.sender == MessageSender.user ? 'user' : 'assistant',
              'text': m.text,
            })
        .toList();

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
    );

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post(
        'chat/',
        data: {
          'message': text,
          'history': historyPayload,
        },
      );

      final replyText = response.data['text'] as String;

      final aiMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: replyText,
        sender: MessageSender.assistant,
        timestamp: timeStr,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMsg],
        isTyping: false,
      );
    } catch (e) {
      final errorMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text:
            "I'm sorry, I encountered an error. Please check your connection and try again.",
        sender: MessageSender.assistant,
        timestamp: timeStr,
      );

      state = state.copyWith(
        messages: [...state.messages, errorMsg],
        isTyping: false,
      );
    }
  }

  void selectSuggestion(String suggestion) {
    sendMessage(suggestion);
  }
}

final chatProvider =
    NotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);
