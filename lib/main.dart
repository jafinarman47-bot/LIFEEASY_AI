import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'controllers/chat_controller.dart';
import 'services/gemini_service.dart';
import 'services/storage_service.dart';
import 'views/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  await storage.init();

  final gemini = GeminiService();
  final apiKey = storage.getApiKey();
  if (apiKey != null && apiKey.isNotEmpty) {
    gemini.init(apiKey);
  }

  runApp(LifeEasyApp(storage: storage, gemini: gemini));
}

class LifeEasyApp extends StatelessWidget {
  final StorageService storage;
  final GeminiService gemini;
  const LifeEasyApp({super.key, required this.storage, required this.gemini});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatController(storage: storage, gemini: gemini)..loadHistory(),
      child: MaterialApp(
        title: 'LifeEasy AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const ChatScreen(),
      ),
    );
  }
}
