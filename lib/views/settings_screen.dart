import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _keyCtrl = TextEditingController();
  String _model = 'gemini-1.5-flash';
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final storage = StorageService();
    await storage.init();
    setState(() {
      _keyCtrl.text = storage.getApiKey() ?? '';
      _model = storage.getModel();
    });
  }

  Future<void> _save() async {
    final storage = StorageService();
    await storage.init();
    await storage.saveApiKey(_keyCtrl.text.trim());
    await storage.saveModel(_model);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved successfully ✔')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Gemini API Key', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _keyCtrl,
            obscureText: _obscure,
            decoration: InputDecoration(
              hintText: 'AIza...',
              filled: true,
              fillColor: AppTheme.surfaceDark,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Get free key: aistudio.google.com/apikey',
            style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 24),
          const Text('Model', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _model,
            dropdownColor: AppTheme.surfaceDark,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.surfaceDark,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
            items: const [
              DropdownMenuItem(value: 'gemini-1.5-flash', child: Text('gemini-1.5-flash (fast)')),
              DropdownMenuItem(value: 'gemini-1.5-pro', child: Text('gemini-1.5-pro (smarter)')),
              DropdownMenuItem(value: 'gemini-2.0-flash-exp', child: Text('gemini-2.0-flash-exp')),
            ],
            onChanged: (v) => setState(() => _model = v ?? _model),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.neonPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _save,
              child: const Text('Save Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'LifeEasy AI v1.0.0\nLIFE EASY • Mahadi Hasan Jewel',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
