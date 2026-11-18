import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/chat_controller.dart';
import '../core/theme.dart';
import '../widgets/message_bubble.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/sidebar.dart';
import 'settings_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scroll.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scroll.animateTo(_scroll.position.maxScrollExtent + 100, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  Future<void> _send() async {
    if (_input.text.trim().isEmpty) return;
    final text = _input.text;
    _input.clear();
    await context.read<ChatController>().send(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ChatController>();
    _scrollToBottom();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        Text('LIFEEASY AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        Text('LIFE EASY COMPANION', style: TextStyle(fontSize: 8, color: AppTheme.textMuted, letterSpacing: 1.5)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white70),
                    onPressed: () => ctrl.clearHistory(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.white70),
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                      if (mounted) await ctrl.refreshApiState();
                    },
                  ),
                ],
              ),
            ),
            if (!ctrl.isReady)
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Gemini API key যুক্ত করুন — Settings আইকনে ট্যাপ করুন।',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            if (ctrl.messages.isEmpty)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3A0CA3), Color(0xFF00B4D8), Color(0xFFF72585)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(color: AppTheme.neonPurple.withOpacity(0.5), blurRadius: 40, spreadRadius: 10),
                          ],
                        ),
                        child: const Center(child: Icon(Icons.blur_on, size: 50, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Hello,', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white70)),
                    const Text('Mahadi Hasan Jewel', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('How can I help you today?', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMuted)),
                    const SizedBox(height: 30),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          QuickActionCard(icon: Icons.lightbulb_outline, title: 'Get Ideas', subtitle: 'For creative projects', iconColor: Colors.amber, onTap: () => _input.text = 'Give me some creative project ideas'),
                          const SizedBox(width: 12),
                          QuickActionCard(icon: Icons.description_outlined, title: 'Summarize', subtitle: 'Articles or text', iconColor: AppTheme.neonBlue, onTap: () => _input.text = 'Summarize this: '),
                          const SizedBox(width: 12),
                          QuickActionCard(icon: Icons.code, title: 'Write Code', subtitle: 'Flutter or Python', iconColor: AppTheme.neonPurple, onTap: () => _input.text = 'Write a clean Flutter widget'),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  itemCount: ctrl.messages.length,
                  itemBuilder: (_, i) {
                    return MessageBubble(
                      message: ctrl.messages[i],
                      isStreaming: ctrl.isStreaming && i == ctrl.messages.length - 1,
                    );
                  },
                ),
              ),
            if (ctrl.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(ctrl.error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
              ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      style: const TextStyle(color: Colors.white),
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Message LifeEasy AI...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: ctrl.isStreaming ? null : _send,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.sendButtonGradient,
                      ),
                      child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
