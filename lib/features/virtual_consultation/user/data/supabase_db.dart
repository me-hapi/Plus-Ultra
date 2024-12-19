import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<List<Map<String, dynamic>>> fetchProfessionals() async {
    try {
      // Perform the join query using Supabase
      final response = await _client.from('professional').select(
          '*, professional_payment(*), professional_clinic(*), professional_availability(*)');

      // Parse and return the data
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching joined data: $e');
      return [];
    }
  }

  Future<void> insertAppointment({
    required String uid,
    required String professionalUid,
    required String status,
  }) async {
    try {
      final createdAt = DateTime.now().toIso8601String();

      final response = await _client.from('appointment').insert({
        'created_at': createdAt,
        'uid': uid,
        'professional_id': professionalUid,
        'status': status
      });

      print('Appointment inserted successfully!');
    } catch (e) {
      print('Error inserting appointment: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchReservedAppointment(String uid) async {
    try {
      final response = await _client
          .from('appointment')
          .select()
          .eq('uid', uid)
          .eq('status', 'reserved')
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
