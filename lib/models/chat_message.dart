class ChatMessage {
  final String id;
  final String role; // 'user' | 'model'
  String content;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  bool get isUser => role == 'user';

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
        id: j['id'],
        role: j['role'],
        content: j['content'],
        timestamp: DateTime.parse(j['timestamp']),
      );
}
