import 'package:lingap/core/const/const.dart';

class SupabaseDb {
  Future<void> updateAge(int age) async {
    try {
      await client.from('profile').update({'age': age}).eq('id', uid);
    } catch (e) {
      print('ERROR updating age: $e');
    }
  }

  Future<void> updateWeight(double value, String label) async {
    try {
      await client
          .from('profile')
          .update({'weight': value, 'weight_lbl': label}).eq('id', uid);
    } catch (e) {
      print('ERROR updating weight: $e');
    }
  }

  Future<void> updateNameAvatar(String name, String avatar) async {
    try {
      await client
          .from('profile')
          .update({'name': name, 'imageUrl': avatar}).eq('id', uid);
    } catch (e) {
      print('ERROR updating avfatar: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchProfile() async {
    try {
      final response = await client
          .from('profile')
          .select('name, age, weight, weight_lbl, imageUrl')
          .eq('id', uid) // Filter by uid
          .single(); // Ensure you get a single record

      return response;
    } catch (e) {
      // Handle and log the error
      print('Error fetching profile: $e');
      return null;
    }
  }
}
