import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/modules/notification/logic/notification_logic.dart';
import 'package:lingap/modules/notification/ui/notification_card.dart';

class NotificationHome extends StatefulWidget {
  @override
  _NotificationHomeState createState() => _NotificationHomeState();
}

class _NotificationHomeState extends State<NotificationHome> {
  final NotificationLogic notif_logic = NotificationLogic();
  Map<String, List<Map<String, dynamic>>> notification = {};

  @override
  void initState() {
    super.initState();
    fetchNotification();
  }

  Future<void> fetchNotification() async {
    final result = await notif_logic.fetchNotification();
    setState(() {
      notification = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Notifications",
              style: TextStyle(
                color: mindfulBrown['Brown80'],
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: notification.entries
                    .where((entry) =>
                        entry.value.isNotEmpty) // Filter out empty categories
                    .map((entry) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                entry.key, // Display category header
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap:
                                  true, // Allows nested ListView inside Column
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevents inner ListView scrolling
                              itemCount: entry.value.length,
                              itemBuilder: (context, index) {
                                return NotificationCard(
                                    category: entry.value[index]['category']);
                              },
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
