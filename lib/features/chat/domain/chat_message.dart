enum MessageSender { user, assistant }

enum MessageStatus { sending, sent, delivered }

class BulletItem {
  final String title;
  final String description;

  const BulletItem({
    required this.title,
    required this.description,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final String timestamp;
  final List<BulletItem>? bulletPoints;
  final String? footerText;
  final MessageStatus status;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.bulletPoints,
    this.footerText,
    this.status = MessageStatus.sent,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    MessageSender? sender,
    String? timestamp,
    List<BulletItem>? bulletPoints,
    String? footerText,
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      bulletPoints: bulletPoints ?? this.bulletPoints,
      footerText: footerText ?? this.footerText,
      status: status ?? this.status,
    );
  }
}
