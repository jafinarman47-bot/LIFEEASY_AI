import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../views/settings_screen.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.bgDark.withOpacity(0.95),
          border: const Border(right: BorderSide(color: Colors.white12)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildNavItem(context, Icons.home_filled, 'Home', true, null),
              _buildNavItem(context, Icons.chat_bubble_outline, 'Chat', false, null),
              _buildNavItem(context, Icons.settings_outlined, 'Settings', false, () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              }),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('LifeEasy AI v1.0.0\nLIFE EASY', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive, VoidCallback? onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: isActive
          ? BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.neonPurple.withOpacity(0.3), Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.neonPurple.withOpacity(0.5)),
            )
          : null,
      child: ListTile(
        leading: Icon(icon, color: isActive ? AppTheme.neonBlue : AppTheme.textMuted),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? AppTheme.textPrimary : AppTheme.textMuted,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }
}
