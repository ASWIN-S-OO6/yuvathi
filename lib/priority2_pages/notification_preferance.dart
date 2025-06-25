import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool whatsappEnabled = true;
  bool smsEnabled = true;
  bool pushNotificationEnabled = true;
  bool appUpdateNotificationEnabled = true;

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
                      'Notification Preferences',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Notification Settings
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
                    _buildNotificationItem(
                      icon: FontAwesomeIcons.whatsapp,
                      title: 'WhatsApp',
                      value: whatsappEnabled,
                      onChanged: (value) {
                        setState(() {
                          whatsappEnabled = value;
                        });
                      },
                    ),
                    _buildNotificationItem(
                      icon: CupertinoIcons.mail,
                      title: 'SMS & Mail',
                      value: smsEnabled,
                      onChanged: (value) {
                        setState(() {
                          smsEnabled = value;
                        });
                      },
                    ),
                    _buildNotificationItem(
                      icon: CupertinoIcons.bell,
                      title: 'Push Notification',
                      value: pushNotificationEnabled,
                      onChanged: (value) {
                        setState(() {
                          pushNotificationEnabled = value;
                        });
                      },
                    ),
                    _buildNotificationItem(
                      icon: CupertinoIcons.arrow_down_circle,
                      title: 'App Update Notification',
                      value: appUpdateNotificationEnabled,
                      onChanged: (value) {
                        setState(() {
                          appUpdateNotificationEnabled = value;
                        });
                      },
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

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
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
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF6B9D),
          ),
        ],
      ),
    );
  }
}
