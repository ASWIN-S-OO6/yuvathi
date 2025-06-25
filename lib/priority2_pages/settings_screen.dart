import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuvathi/priority2_pages/update_page.dart';
import 'package:yuvathi/walkthrough_screens/language_selection_screen.dart';

import '../components/My_drawer.dart';
import 'language_screen_settingspage.dart';
import 'notification_preferance.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF6B9D),
              Color(0xFFFFB6C1),
            ],
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Settings Menu
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.only(top: 20),
                  children: [
                    _buildSettingsMenuItem(
                      context,
                      icon: CupertinoIcons.bell,
                      title: 'Notification Preference',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NotificationPreferencesScreen(),
                        ),
                      ),
                    ),
                    _buildSettingsMenuItem(
                      context,
                      icon: CupertinoIcons.lock_shield,
                      title: 'Permissions',
                      onTap: () {},
                    ),
                    _buildSettingsMenuItem(
                      context,
                      icon: CupertinoIcons.globe,
                      title: 'Languages',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LanguageScreen2(),
                        ),
                      ),
                    ),
                    _buildSettingsMenuItem(
                      context,
                      icon: CupertinoIcons.arrow_down_circle,
                      title: 'App Updates',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UpdatePage(),
                        ),
                      ),
                    ),
                    _buildSettingsMenuItem(
                      context,
                      icon: CupertinoIcons.trash,
                      title: 'Delete Account',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B9D).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFFF6B9D),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        CupertinoIcons.chevron_right,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
