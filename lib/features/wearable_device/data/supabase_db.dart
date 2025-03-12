import 'dart:async';
import 'package:lingap/core/const/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  /// Inserts health data history into the `vital` table one by one.
  Future<void> insertHealthHistory(List<Map<String, dynamic>> history) async {
    for (var entry in history) {
      String healthUID = entry['uid'];
      String entryDate = entry['date'];

      try {
        // Check if the uid already exists
        final response = await client
            .from('vital')
            .select()
            .eq('health_id', healthUID)
            .eq('date', entryDate)
            .eq('uid', uid)
            .maybeSingle();

        if (response == null) {
          // If UID does not exist, insert new record
          await client.from('vital').insert({
            'health_id': healthUID,
            'uid': uid,
            'type': entry['type'],
            'date': entry['date'],
            'value': entry['value'].toString(),
          });
          print('Inserted new health record: $entry');
        } else {
          print('Record with UID $healthUID already exists. Skipping...');
        }
      } catch (e) {
        print('Error inserting health record for UID $healthUID: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchVitalData() async {
    try {
      final result = await client.from('vital').select().eq('uid', uid);

      return result;
    } catch (e) {
      print('ERROR fetching vital: $e');
      return [];
    }
  }
}
