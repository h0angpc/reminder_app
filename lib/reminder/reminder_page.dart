import 'package:flutter/material.dart';
import 'package:reminder_app/domain/remider.dart';
import 'package:reminder_app/login/login_page.dart';
import 'package:reminder_app/reminder/add_reminder_page.dart';

class ReminderListPage extends StatefulWidget {
  const ReminderListPage({super.key});

  @override
  _ReminderListPageState createState() => _ReminderListPageState();
}

class _ReminderListPageState extends State<ReminderListPage> {
  List<Reminder> reminders = [];

  void _navigateToAddReminder() async {
    final newReminder = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddReminderPage()),
    );

    if (newReminder != null) {
      setState(() {
        reminders.add(newReminder);
        reminders.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      });
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateString;
    if (date == today) {
      dateString = 'Hôm nay';
    } else if (date == today.add(const Duration(days: 1))) {
      dateString = 'Ngày mai';
    } else {
      dateString = '${date.day}/${date.month}/${date.year}';
    }

    final timeString = TimeOfDay.fromDateTime(dateTime).format(context);
    return '$dateString lúc $timeString';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Reminders",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: reminders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.black26,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Chưa có ghi chú nào",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Nhấn + để thêm ghi chú",
                    style: TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: reminders.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Colors.black12,
              ),
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withAlpha(1),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      reminder.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      _formatDateTime(reminder.dateTime),
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.circle,
                      color: Colors.black26,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddReminder,
        backgroundColor: Colors.black,
        elevation: 2,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
