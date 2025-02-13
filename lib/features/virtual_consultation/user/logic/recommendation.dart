import 'dart:math';

import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/data/supabase_db.dart';

class Recommender {
  final SupabaseDB supabaseDB = SupabaseDB(client);

  Future<Map<String, dynamic>> recommendProfessional(
      double userLat, double userLong) async {
    final mhScore = await supabaseDB.fetchMHScore(uid);
    final professionalData = await supabaseDB.fetchProfessionals();
    final fetchIssue = await supabaseDB.fetchIssue(uid);

    // print('mhscore: $mhScore \n issue: $fetchIssue \n professionals : $professionalData');

    // Define suitable professions based on MH score
    List<String> suitableProfessions = _getSuitableProfessions(mhScore!);

    // Filter professionals based on job suitability
    List<Map<String, dynamic>> filteredProfessionals = professionalData
        .where((prof) => suitableProfessions.contains(prof['job']))
        .toList();

    // Filter professionals based on specialty matching fetchIssue
    filteredProfessionals = filteredProfessionals
        .where((prof) =>
            prof['specialty'] != null && prof['specialty'].contains(fetchIssue))
        .toList();

    // If no professionals left after filtering, return the first available
    if (filteredProfessionals.isEmpty) {
      return professionalData.isNotEmpty ? professionalData.first : {};
    }

    // Find the nearest professional
    Map<String, dynamic>? bestProfessional;
    double minDistance = double.infinity;

    for (var prof in filteredProfessionals) {
      double clinicLat = prof['professional_clinic']['clinic_lat'] ?? 0;
      double clinicLong = prof['professional_clinic']['clinic_long'] ?? 0;
      double distance =
          calculateDistance(userLat, userLong, clinicLat, clinicLong);

      if (distance < minDistance) {
        minDistance = distance;
        bestProfessional = prof;
      }
    }

    // If nearest professional is more than 30km away, pick one offering teleconsultation
    if (minDistance > 30) {
      var teleConsultationProfessionals = filteredProfessionals
          .where((prof) => prof['professional_clinic']['clinic_name'] == null)
          .toList();
      if (teleConsultationProfessionals.isNotEmpty) {
        bestProfessional = teleConsultationProfessionals.first;
      }
    }
    print(bestProfessional ?? filteredProfessionals.first);
    return bestProfessional ?? filteredProfessionals.first;
  }

  List<String> _getSuitableProfessions(Map<String, dynamic> mhScore) {
    if (mhScore['depression'] > 10 ||
        mhScore['anxiety'] > 10 ||
        mhScore['stress'] > 10) {
      return ['psychologist', 'psychiatrist'];
    }
    return ['social worker', 'guidance counselor'];
  }

  double calculateDistance(
      double userLat, double userLong, double clinicLat, double clinicLong) {
    const double earthRadius = 6371; // Radius of the Earth in km
    double dLat = _degreesToRadians(clinicLat - userLat);
    double dLon = _degreesToRadians(clinicLong - userLong);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(userLat)) *
            cos(_degreesToRadians(clinicLat)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in km
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Future<Map<String, dynamic>> fetchMhScore() async {
  //   // Simulated fetch from Supabase
  //   return {'depression': 12, 'anxiety': 8, 'stress': 5};
  // }

  // Future<List<Map<String, dynamic>>> fetchProfessionalData() async {
  //   // Simulated fetch from Supabase
  //   return [
  //     {
  //       'name': 'Dr. Jane Doe',
  //       'job': 'psychologist',
  //       'profileUrl': 'https://example.com/image.jpg',
  //       'professional_clinic': {
  //         'clinic_address': '123 Street',
  //         'clinic_name': 'Mind Wellness Clinic',
  //         'clinic_lat': 14.5995,
  //         'clinic_long': 120.9842
  //       },
  //       'specialty': ['anxiety', 'depression']
  //     }
  //   ];
  // }

  // Future<String> fetchIssue() async {
  //   // Simulated fetch from chatbot
  //   return 'anxiety';
  // }
}
