import 'package:lingap/modules/notification/data/supabase_db.dart';

class NotificationLogic {
  final SupabaseDB supabase = SupabaseDB();

  Future<Map<String, List<Map<String, dynamic>>>> fetchNotification() async {
    final result = await supabase.fetchNotification();

    return processNotifications(result);
  }

  Map<String, List<Map<String, dynamic>>> processNotifications(
      Map<String, dynamic> result) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final startOfLastWeek = startOfWeek.subtract(Duration(days: 7));
    final startOfMonth = DateTime(now.year, now.month, 1);

    Map<String, List<Map<String, dynamic>>> categorizedNotifications = {
      'Today': [],
      'Earlier this week': [],
      'Last week': [],
      'Earlier this month': [],
    };

    List<String> categories = [
      'appointment',
      'journal',
      'mindfulness',
      'session',
      'mood',
      'sleep',
      'messages'
    ];

    for (var category in categories) {
      if (result.containsKey(category)) {
        for (var item in result[category]) {
          DateTime createdAt = DateTime.parse(item['created_at']);
          Map<String, dynamic> notificationItem = {
            'category': category,
            'created_at': createdAt
          };

          if (createdAt.isAfter(today)) {
            categorizedNotifications['Today']!.add(notificationItem);
          } else if (createdAt.isAfter(startOfWeek)) {
            categorizedNotifications['Earlier this week']!
                .add(notificationItem);
          } else if (createdAt.isAfter(startOfLastWeek)) {
            categorizedNotifications['Last week']!.add(notificationItem);
          } else if (createdAt.isAfter(startOfMonth)) {
            categorizedNotifications['Earlier this month']!
                .add(notificationItem);
          }
        }
      }
    }

    // Sorting each category based on created_at in descending order
    categorizedNotifications.forEach((key, list) {
      list.sort((a, b) => b['created_at'].compareTo(a['created_at']));
    });
    print('CATEGORY: $categorizedNotifications');
    return categorizedNotifications;
  }
}
