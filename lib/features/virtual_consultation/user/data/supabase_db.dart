import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDB {
  final SupabaseClient _client;

  SupabaseDB(this._client);

  Future<void> updateAppointment(int appointmentId) async {
    final response = await _client
        .from('appointment')
        .update({'status': 'completed'}).eq('id', appointmentId);
  }

  Future<Map<String, dynamic>?> fetchMHScore(String uid) async {
    final response = await _client
        .from('mh_score')
        .select()
        .eq('uid', uid)
        .order('created_at', ascending: false)
        .limit(1)
        .single();

    return response;
  }

  Future<String?> fetchIssue(String uid) async {
    final response = await _client
        .from('session')
        .select('issue')
        .eq('uid', uid) // Filter by UID
        .eq('open', false) // Filter where open is false
        .order('created_at', ascending: false) // Order by latest created_at
        .limit(1) // Limit to 1 row
        .maybeSingle(); // Return single row or null if not found

    return response?['issue'] as String?;
  }

  Future<List<Map<String, dynamic>>> fetchProfessionals() async {
    try {
      // Perform the join query using Supabase
      final response = await _client.from('professional').select(
          '*, professional_payment(*), professional_clinic(*), professional_availability(*), specialty(*), experience(*)');

      // Parse and return the data
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching joined data: $e');
      return [];
    }
  }

  Future<void> insertRoom(
      {required String uid,
      required String professionalUid,
      required String roomId,
      required int appointmenId}) async {
    try {
      final response = await _client.from('consultation_room').insert({
        'room_id': roomId,
        'professional_uid': professionalUid,
        'user_uid': uid,
        'appointment_id': appointmenId
      });

      print('room inserted successfully!');
    } catch (e) {
      print('Error inserting room: $e');
    }
  }

  Future<int> insertAppointment({
    required String uid,
    required String professionalUid,
    required String status,
    required Map<String, dynamic> stepData,
  }) async {
    try {
      final createdAt = DateTime.now().toIso8601String();

      // Extract user_details and time_date from stepData
      final userDetails = stepData['user_details'] as Map<String, dynamic>;
      final timeDate = stepData['time_date'] as Map<String, dynamic>;

      final appointmentDate =
          (timeDate['selectedDate'] as DateTime).toIso8601String();

      final response = await _client.from('appointment').insert({
        'created_at': createdAt,
        'uid': uid,
        'professional_id': professionalUid,
        'status': status,
        // User Details
        'full_name': userDetails['fullName'],
        'email': userDetails['email'],
        'mobile': userDetails['mobile'],
        'gender': userDetails['gender'],
        'age': userDetails['age'],
        'comment': userDetails['comments'],
        // Date and timeslot
        'appointment_date': appointmentDate, // Use ISO8601 string
        'time_slot': timeDate['selectedTimeSlot'],
      }).select('id');

      print('Appointment inserted successfully!');
      return response[0]['id'];
    } catch (e) {
      print('Error inserting appointment: $e');
      return 0;
    }
  }

  Future<Map<String, dynamic>?> fetchReservedAppointment(String uid) async {
    try {
      final response = await _client
          .from('appointment')
          .select('*, consultation_room(*)')
          .eq('uid', uid)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchReservedProfessional(String uid) async {
    try {
      final response = await _client
          .from('professional')
          .select(
              '*, professional_payment(*), professional_clinic(*), professional_availability(*), specialty(*), experience(*)')
          .eq('uid', uid)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchAppointmentHistory() async {
    final supabase = Supabase.instance.client;

    try {
      // Fetch appointments with related professional details
      final response = await supabase.from('appointment').select(
          'appointment_date, status, professional:professional_id(name, uid, profileUrl, job)');

      final appointments = response as List;

      // Group data by professional name
      final Map<String, Map<String, dynamic>> groupedData = {};

      for (var appointment in appointments) {
        final professional = appointment['professional'];
        final professionalName = professional['name'];
        final profileUrl = professional['profileUrl'];
        final job = professional['job'];
        final date = appointment['appointment_date'];
        final status = appointment['status'];

        if (!groupedData.containsKey(professionalName)) {
          // Initialize a new group for the professional
          groupedData[professionalName] = {
            'profile': profileUrl,
            'job': job,
            'name': professionalName,
            'dates': [
              {'date': date, 'status': status}
            ]
          };
        } else {
          // Add new date and status to the existing group
          groupedData[professionalName]!['dates']
              .add({'date': date, 'status': status});
        }
      }

      // Prepare final merged result
      final List<Map<String, dynamic>> mergedResults = groupedData.entries
          .map((entry) => {
                'job': entry.value['job'],
                'profile': entry.value['profile'],
                'name': entry.value['name'],
                'dates': entry.value['dates'], // List of dates and statuses
              })
          .toList();

      return mergedResults;
    } catch (e) {
      return null;
    }
  }
}
