import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/constants.dart';
import '../models/chat_message.dart';

class GeminiService {
  GenerativeModel? _model;
  String _currentModel = AppConstants.defaultModel;

  bool get isReady => _model != null;
  String get currentModel => _currentModel;

  void init(String apiKey, {String? modelName}) {
    _currentModel = modelName ?? _currentModel;
    _model = GenerativeModel(
      model: _currentModel,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 2048,
      ),
      systemInstruction: Content.system(AppConstants.systemPrompt),
    );
  }

  void reset() {
    _model = null;
  }

  Stream<String> streamReply({
    required String userMessage,
    required List<ChatMessage> history,
  }) async* {
    if (_model == null) {
      throw Exception('API key not configured. Please add it in Settings.');
    }

    final chat = _model!.startChat(history: _buildHistory(history));
    final response = chat.sendMessageStream(Content.text(userMessage));

    await for (final chunk in response) {
      final text = chunk.text;
      if (text != null && text.isNotEmpty) yield text;
    }
  }

  List<Content> _buildHistory(List<ChatMessage> messages) {
    return messages
        .where((m) => m.content.trim().isNotEmpty)
        .map((m) => Content(
              m.isUser ? 'user' : 'model',
              [TextPart(m.content)],
            ))
        .toList();
  }
}
