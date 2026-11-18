import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../core/theme.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isStreaming;

  const MessageBubble({super.key, required this.message, this.isStreaming = false});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32, height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppTheme.neonBlue, AppTheme.neonPurple]),
                boxShadow: [BoxShadow(color: AppTheme.neonBlue, blurRadius: 10)],
              ),
              child: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isUser ? AppTheme.userBubbleGradient : null,
                color: isUser ? null : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 20),
                ),
                border: isUser ? null : Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: isUser
                  ? Text(message.content, style: const TextStyle(color: Colors.white, fontSize: 15))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MarkdownBody(
                          data: message.content.isEmpty && isStreaming ? '...' : message.content,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, height: 1.5),
                            code: const TextStyle(backgroundColor: Colors.black45, color: AppTheme.neonBlue),
                          ),
                        ),
                        if (isStreaming)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.neonBlue)),
                                SizedBox(width: 8),
                                Text('Thinking...', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.neonPurple,
                border: Border.all(color: AppTheme.neonPurple, width: 1.5),
              ),
              child: const Center(child: Text('MH', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))),
            ),
          ],
        ],
      ),
    );
  }
}
