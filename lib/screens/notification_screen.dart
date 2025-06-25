import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconColor;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontScale = screenWidth / 360;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'Notifications',
          style: TextStyle( color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 28 * fontScale, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: NotificationContent(),
      ),
    );
  }
}

class NotificationContent extends StatefulWidget {
  const NotificationContent({super.key});

  @override
  _NotificationContentState createState() => _NotificationContentState();
}

class _NotificationContentState extends State<NotificationContent> {
  DateTime selectedDay = DateTime.now();
  String selectedDateFilter = 'Today';

  // Store notifications for different dates
  Map<DateTime, List<NotificationItem>> notificationsByDate = {};

  @override
  void initState() {
    super.initState();
    // Initialize with some sample notifications for today (June 15, 2025)
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    notificationsByDate[today] = getTodayNotifications();

    // Add some sample notifications for other dates
    DateTime tomorrow = today.add(Duration(days: 1));
    notificationsByDate[tomorrow] = [
      NotificationItem(
        title: "Appointment Reminder",
        description: "Doctor appointment at 10:00 AM on 16 June 2025.",
        time: "09:00 AM",
        icon: Icons.medical_services,
        iconColor: Colors.green,
      ),
    ];

    DateTime yesterday = today.subtract(Duration(days: 1));
    notificationsByDate[yesterday] = [
      NotificationItem(
        title: "Order Confirmed",
        description: "Your order #12345 has been confirmed and will be processed soon.",
        time: "02:30 PM",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      ),
      NotificationItem(
        title: "Shipping Update",
        description: "Your package is now in transit and will arrive within 2-3 business days.",
        time: "11:15 AM",
        icon: Icons.local_shipping,
        iconColor: Colors.orange,
      ),
    ];
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDay) {
      setState(() {
        selectedDay = picked;
        selectedDateFilter = _formatDateFilter(picked);
      });
    }
  }

  String _formatDateFilter(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDayNormalized = DateTime(date.year, date.month, date.day);

    if (selectedDayNormalized == today) {
      return 'Today';
    } else if (selectedDayNormalized == today.subtract(Duration(days: 1))) {
      return 'Yesterday';
    } else if (selectedDayNormalized == today.add(Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  List<NotificationItem> getTodayNotifications() {
    return [
      NotificationItem(
        title: "Download Your Report!",
        description: "Tap below to download your test report.\n-Yuvathi Tap Here.",
        time: "03:59 PM",
        icon: Icons.file_download,
        iconColor: Colors.blue,
      ),
      NotificationItem(
        title: "Payment Successfully",
        description:
        "Your credit card **4125 bill is due on 15 October 2025. To avoid extra charges, kindly pay the outstanding amount before the due date.",
        time: "03:59 PM",
        icon: Icons.payment,
        iconColor: Colors.green,
      ),
      NotificationItem(
        title: "Payment Failed",
        description:
        "Your credit card **4125 bill is due on 15 October 2025. To avoid extra charges, kindly pay the outstanding amount before the due date.",
        time: "03:59 PM",
        icon: Icons.payment,
        iconColor: Colors.red,
      ),
      NotificationItem(
        title: "Your pickup is scheduled!",
        description:
        "We will pick up your CerviScan Kit from 128 MG Road, Bangalore on 9 May 2025. Tap for view details. -Yuvathi",
        time: "03:59 PM",
        icon: Icons.local_shipping,
        iconColor: Colors.orange,
      ),
      NotificationItem(
        title: "Order Delivered!",
        description:
        "Your order #23456 (CerviScan Kit) has been delivered to MG Road, Bangalore on 14 June 2025. Tap to view details. -Yuvathi",
        time: "03:59 PM",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      ),
    ];
  }

  List<NotificationItem> getNotificationsForDate(DateTime date) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    return notificationsByDate[normalizedDate] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    List<NotificationItem> currentNotifications = getNotificationsForDate(selectedDay);

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pink.shade50.withOpacity(0.9),
            Colors.pink.shade50.withOpacity(0.5),
            Colors.pink.shade50.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            children: [
              // Header section with sort options
              Container(
                color: Colors.pink[50],
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Latest Notifications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Sort by Date',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: _showDatePicker,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.pink[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  selectedDateFilter,
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.calendar_today, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Date filter info
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[600], size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Showing notifications for: $selectedDateFilter',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Notifications list
              currentNotifications.isEmpty
                  ? Container(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No notifications for $selectedDateFilter',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: currentNotifications.length,
                itemBuilder: (context, index) {
                  final notification = currentNotifications[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: notification.iconColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            notification.icon,
                            color: notification.iconColor,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.pink[400],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    notification.time,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                notification.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Add bottom padding for navigation bar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}