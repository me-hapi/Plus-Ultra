import 'package:lingap/modules/notification/data/supabase_db.dart';

class NotificationLogic {
  final SupabaseDB supabase = SupabaseDB();

  Future<void> updateNotification() async {
    await supabase.updateNotification();
    print('UPDATED SUCCESS');
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchAllNotification() async {
    final result = await supabase.fetchAllNotification();
    print(result);
    return processNotifications(result);
  }

  Map<String, List<Map<String, dynamic>>> processNotifications(
      List<Map<String, dynamic>> result) {
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

    for (var item in result) {
      DateTime createdAt = DateTime.parse(item['created_at']);
      String category = item['category'];

      Duration difference = now.difference(createdAt);
      String timeAgo = '';
      if (difference.inMinutes < 60) {
        timeAgo = '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        timeAgo = '${difference.inHours}h ago';
      }

      Map<String, dynamic> notificationItem = {
        'content': item['content'],
        'category': category,
        'created_at': createdAt,
        'time_ago': timeAgo.isNotEmpty ? timeAgo : createdAt.toString()
      };

      if (createdAt.isAfter(today)) {
        categorizedNotifications['Today']!.add(notificationItem);
      } else if (createdAt.isAfter(startOfWeek)) {
        categorizedNotifications['Earlier this week']!.add(notificationItem);
      } else if (createdAt.isAfter(startOfLastWeek)) {
        categorizedNotifications['Last week']!.add(notificationItem);
      } else if (createdAt.isAfter(startOfMonth)) {
        categorizedNotifications['Earlier this month']!.add(notificationItem);
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
