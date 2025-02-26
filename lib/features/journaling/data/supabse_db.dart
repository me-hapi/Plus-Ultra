import 'dart:async';
import 'dart:io';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/journaling/model/journal_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<List<Map<String, dynamic>>> fetchJournalCount() async {
    try {
      final response = await _client.from('journal').select().eq('uid', uid);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<int> insertJournal(
      String uid, String title, List<JournalItem> journalItems) async {
    try {
      // Insert into journal table
      final response = await _client
          .from('journal')
          .insert({
            'uid': uid,
            'title': title,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select('id')
          .single();

      final journalId = response['id'];

      // Prepare and insert journal items
      for (int position = 0; position < journalItems.length; position++) {
        final item = journalItems[position];
        final contentType = item.type;

        String? publicUrl;
        if (contentType == 'image' && item.imageFile != null) {
          // Upload image to bucket
          final filePath =
              'journal_images/$uid/${DateTime.now().millisecondsSinceEpoch}_${position}.jpg';
          await _client.storage
              .from('journal_image')
              .upload(filePath, item.imageFile!);

          // Get public URL of the uploaded image
          publicUrl =
              _client.storage.from('journal_image').getPublicUrl(filePath);
        } else if (contentType == 'audio' && item.audioPath != null) {
          // Upload audio to bucket
          final audioFile = File(item.audioPath!);
          final filePath =
              'journal_audios/$uid/${DateTime.now().millisecondsSinceEpoch}_${position}.mp3';
          await _client.storage
              .from('journal_audio')
              .upload(filePath, audioFile);

          // Get public URL of the uploaded audio
          publicUrl =
              _client.storage.from('journal_audio').getPublicUrl(filePath);
        }

        // Insert journal item
        await _client.from('journal_item').insert({
          'journal_id': journalId,
          'content_type': contentType,
          'content': publicUrl ?? item.text, // Store the URL or text content
          'position': position,
        });
      }

      return journalId;
    } catch (error) {
      print('Error inserting journal: $error');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getClassifications({
    required String uid,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _client
          .from('journal')
          .select('classification, created_at')
          .eq('uid', uid)
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', endDate.toIso8601String());

      print('response: $response');

      final results = response
          .map((entry) => {
                'classification': entry['classification'] as String,
                'created_at': entry['created_at'] as String,
              })
          .toList();

      return response;
    } catch (error) {
      print('Error retrieving classifications: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getJournalsWithItems({
    required String uid,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _client
          .from('journal')
          .select('*, journal_item(*)')
          .eq('uid', uid)
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', endDate.toIso8601String());

      final results = (response as List<dynamic>).map((entry) {
        // Extract journal_items as a list
        final journalItems =
            (entry['journal_item'] as List<dynamic>).map((item) {
          return {
            'id': item['id'],
            'journal_id': item['journal_id'],
            'content':
                item['content'], // Replace with actual fields in journal_items
            'content_type': item['content_type'],
            'position': item['position']
          };
        }).toList();

        return {
          'id': entry['id'] as int,
          'title': entry['title'],
          'classification': entry['classification'] as String,
          'emotion': entry['emotion'],
          'created_at': entry['created_at'] as String,
          'journalItems': journalItems,
        };
      }).toList();

      return results;
    } catch (error) {
      print('Error retrieving journals with items: $error');
      return [];
    }
  }
}
