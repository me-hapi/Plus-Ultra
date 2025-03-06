import 'dart:async';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lingap/core/const/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playNotificationSound() async {
    try {
      await _player.setAsset('assets/notification.mp3'); // Load the asset
      await _player.play(); // Play the audio
    } catch (e) {
      print('Error playing notification sound: $e');
    }
  }

  Future<void> updateNotification() async {
    try {
      await client.from('notification').update({'read': true}).eq('uid', uid);
      print('UPDATED');
    } catch (e) {
      print('error notification $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllNotification() async {
    try {
      final result = await client.from('notification').select().eq('uid', uid);
      return result;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchNotification() async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final result = await client
          .from('profile')
          .select(
              'id, appointment(appointment_date, status), journal(created_at), mood(created_at), sleep(created_at)')
          .eq('id', uid)
          .maybeSingle();

      Map<String, bool> hasTodayRecord = {
        'appointment': false,
        'journal': false,
        'mood': false,
        'sleep': false,
      };

      if (result != null) {
        // Check journal, mood, and sleep records
        for (final key in ['journal', 'mood', 'sleep']) {
          if (result[key] != null && result[key].isNotEmpty) {
            for (var record in result[key]) {
              if (record['created_at'].toString().startsWith(today)) {
                hasTodayRecord[key] = true;
                break;
              }
            }
          }
        }

        // Check appointment date and status
        if (result['appointment'] != null && result['appointment'].isNotEmpty) {
          for (var appointment in result['appointment']) {
            if (appointment['appointment_date'].toString().startsWith(today) &&
                appointment['status'] == 'approved') {
              hasTodayRecord['appointment'] = true;
              break;
            }
          }
        }
      }

      final rooms = await getPeerRoomIds(uid);
      final messages = await getLatestMessagesPerRoom(rooms, uid);

      return {...hasTodayRecord, 'messages': messages};
    } catch (e) {
      print('ERROR fetching vital: $e');
      return {
        'appointment': false,
        'journal': false,
        'mood': false,
        'sleep': false,
        'messages': []
      };
    }
  }

  Future<void> insertNotifications() async {
    try {
      // Fetch existing notifications for today using timestamp filtering
      final todayStart = DateTime.now()
          .toUtc()
          .toIso8601String()
          .substring(0, 10); // YYYY-MM-DD
      final todayStartTimestamp = DateTime.parse("$todayStart 00:00:00Z");
      final todayEndTimestamp = DateTime.parse("$todayStart 23:59:59Z");

      final existingNotifications = await client
          .from('notification')
          .select('content')
          .eq('uid', uid)
          .gte('created_at', todayStartTimestamp.toIso8601String())
          .lt('created_at', todayEndTimestamp.toIso8601String());

      Set<String> existingContents = {
        for (var row in existingNotifications) row['content']
      };

      // Fetch notification status
      final notifications = await fetchNotification();

      List<Map<String, dynamic>> newNotifications = [];

      // Define the content messages with categories
      final Map<String, Map<String, String>> notificationMessages = {
        'appointment': {
          'content': 'You have an appointment today.',
          'category': 'Appointments'
        },
        'journal': {
          'content': 'Don’t forget to write in your journal!',
          'category': 'Journaling'
        },
        'mood': {
          'content': 'Log your mood to track your well-being.',
          'category': 'Mood Tracking'
        },
        'sleep': {
          'content': 'Monitor your sleep for better health.',
          'category': 'Sleep Monitoring'
        },
      };

      // Insert appointment notification only if it is TRUE
      if (notifications['appointment'] == true &&
          !existingContents
              .contains(notificationMessages['appointment']!['content'])) {
        newNotifications.add({
          'uid': uid,
          'content': notificationMessages['appointment']!['content'],
          'category': notificationMessages['appointment']!['category'],
        });
      }

      // Insert journal, mood, sleep notifications only if they are FALSE
      for (var key in ['journal', 'mood', 'sleep']) {
        if (notifications[key] == false &&
            !existingContents.contains(notificationMessages[key]!['content'])) {
          newNotifications.add({
            'uid': uid,
            'content': notificationMessages[key]!['content'],
            'category': notificationMessages[key]!['category'],
          });
        }
      }

      // Insert messages from peer chat with "Messaging" category
      for (var message in notifications['messages']) {
        final content = 'Someone sent you a message';
        if (!existingContents.contains(content)) {
          newNotifications.add({
            'uid': uid,
            'content': content,
            'category': 'Messaging',
          });
        }
      }

      // Insert new notifications in batch
      if (newNotifications.isNotEmpty) {
        await client.from('notification').insert(newNotifications);
        print('Inserted ${newNotifications.length} new notifications.');
        playNotificationSound();
      } else {
        print('No new notifications to insert.');
      }
    } catch (e) {
      print('Error inserting notifications: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getLatestMessagesPerRoom(
      List<int> roomIds, String uid) async {
    if (roomIds.isEmpty) return [];

    try {
      final response = await client
          .from('peer_messages')
          .select('created_at, room_id')
          .neq('sender', uid)
          .eq('read', false)
          .inFilter('room_id', roomIds)
          .order('created_at', ascending: false);

      Map<int, Map<String, dynamic>> latestMessages = {};

      for (var msg in response) {
        int roomId = msg['room_id'];
        if (!latestMessages.containsKey(roomId)) {
          latestMessages[roomId] = msg;
        }
      }

      return latestMessages.values.toList();
    } catch (error) {
      print('Error fetching latest messages per room: $error');
      return [];
    }
  }

  Future<List<int>> getPeerRoomIds(String uid) async {
    try {
      final response = await client
          .from('peer_room')
          .select('id')
          .or('sender.eq.$uid,receiver.eq.$uid');

      return response.map((e) => e['id'] as int).toList();
    } catch (error) {
      print('Error fetching peer room IDs: $error');
      return [];
    }
  }
}
