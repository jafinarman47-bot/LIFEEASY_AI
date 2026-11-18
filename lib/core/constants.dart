class AppConstants {
  static const String appName = 'LifeEasy AI';
  static const String company = 'LIFE EASY';
  static const String author = 'Mahadi Hasan Jewel';
  static const String defaultModel = 'gemini-1.5-flash';

  static const String systemPrompt = '''
You are LifeEasy AI — an autonomous, multi-functional AI assistant created by LIFE EASY.
You can reason, plan, code, search, and break down complex tasks step by step.
Respond in the user's language (Bangla or English). Be concise, helpful, and proactive.
''';

  static const List<String> quickPrompts = [
    'Summarize this text for me',
    'Write a Flutter widget for a login screen',
    'Plan a 7-day trip to Cox\'s Bazar',
    'Explain quantum computing simply',
  ];
}
