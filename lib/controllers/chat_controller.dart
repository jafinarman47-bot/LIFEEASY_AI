import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../services/storage_service.dart';

class ChatController extends ChangeNotifier {
  final StorageService _storage;
  final GeminiService _gemini;

  ChatController({required StorageService storage, required GeminiService gemini})
      : _storage = storage,
        _gemini = gemini;

  final List<ChatMessage> _messages = [];
  bool _isStreaming = false;
  String? _error;
  String? _streamingId;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isStreaming => _isStreaming;
  String? get error => _error;
  bool get isReady => _gemini.isReady;

  void loadHistory() {
    _messages
      ..clear()
      ..addAll(_storage.loadMessages());
    notifyListeners();
  }

  Future<void> refreshApiState() async {
    final key = _storage.getApiKey();
    if (key != null && key.isNotEmpty) {
      _gemini.init(key, modelName: _storage.getModel());
    } else {
      _gemini.reset();
    }
    notifyListeners();
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isStreaming) return;
    _error = null;

    if (!_gemini.isReady) {
      _error = '⚠️ API key set করা হয়নি। Settings-এ গিয়ে Gemini API key দিন।';
      notifyListeners();
      return;
    }

    final userMsg = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: 'user',
      content: trimmed,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);

    final historySnapshot = List<ChatMessage>.from(_messages);
    final aiMsg = ChatMessage(
      id: '${DateTime.now().microsecondsSinceEpoch}_ai',
      role: 'model',
      content: '',
      timestamp: DateTime.now(),
    );
    _messages.add(aiMsg);
    _streamingId = aiMsg.id;
    _isStreaming = true;
    notifyListeners();

    try {
      final stream = _gemini.streamReply(
        userMessage: trimmed,
        history: historySnapshot,
      );

      await for (final chunk in stream) {
        aiMsg.content += chunk;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
      if (aiMsg.content.isEmpty) _messages.remove(aiMsg);
    } finally {
      _isStreaming = false;
      _streamingId = null;
      await _storage.saveMessages(_messages);
      notifyListeners();
    }
  }

  Future<void> clearHistory() async {
    _messages.clear();
    await _storage.clearMessages();
    notifyListeners();
  }

  String get streamingId => _streamingId ?? '';
}
