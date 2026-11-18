import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';

class StorageService {
  static const _chatBox = 'chat_history';
  static const _apiKeyPref = 'gemini_api_key';
  static const _modelPref = 'gemini_model';

  late Box<String> _box;
  SharedPreferences? _prefs;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_chatBox);
    _prefs = await SharedPreferences.getInstance();
  }

  List<ChatMessage> loadMessages() {
    final raw = _box.get('messages');
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveMessages(List<ChatMessage> msgs) async {
    final raw = jsonEncode(msgs.map((m) => m.toJson()).toList());
    await _box.put('messages', raw);
  }

  Future<void> clearMessages() async => _box.delete('messages');

  String? getApiKey() => _prefs?.getString(_apiKeyPref);
  Future<void> saveApiKey(String key) async => _prefs?.setString(_apiKeyPref, key);

  String getModel() => _prefs?.getString(_modelPref) ?? 'gemini-1.5-flash';
  Future<void> saveModel(String m) async => _prefs?.setString(_modelPref, m);
}
