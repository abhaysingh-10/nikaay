import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;

    if (isUser) {
      return _buildUserBubble(context);
    } else {
      return _buildAssistantBubble(context);
    }
  }

  Widget _buildUserBubble(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 48.0, right: 16.0, top: 6.0, bottom: 6.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          decoration: const BoxDecoration(
            color: Color(0xFF346838),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(4.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.timestamp,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 10.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssistantBubble(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 36.0, top: 6.0, bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Robot Avatar (Same as App Bar)
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              'assets/chat/chat_avatar.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy_outlined,
                    color: AppColors.primaryGreen,
                    size: 18,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),

          // Message Card Body
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
                border: Border.all(
                  color: const Color(0xFFF0EBE1),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main text content
                  Text(
                    message.text,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14.5,
                      height: 1.4,
                    ),
                  ),

                  // Bullet Points (Ingredients / Checkmarks)
                  if (message.bulletPoints != null &&
                      message.bulletPoints!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    ...message.bulletPoints!.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Color(0xFF388E3C),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    color: AppColors.primaryText,
                                    height: 1.35,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' – ${item.description}',
                                      style: const TextStyle(
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Footer text
                  if (message.footerText != null &&
                      message.footerText!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      message.footerText!,
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 13.5,
                        height: 1.35,
                      ),
                    ),
                  ],

                  const SizedBox(height: 6),

                  // Timestamp
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      message.timestamp,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
