import 'package:flutter/material.dart';
import 'dart:math';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/peer_connect/data/supabase_db.dart';

class Matchmaking {
  final SupabaseDB _supabaseDB = SupabaseDB(client);

  Future<List<Map<String, dynamic>>> findTopRooms(String uid) async {
    final userScore = await _supabaseDB.fetchMHScore(uid);
    if (userScore == null) {
      return [];
    }

    final allRooms = await _supabaseDB.fetchAvailableRooms();
    List<Map<String, dynamic>> roomDistances = [];

    for (final room in allRooms) {
      final double distance = calculateEuclideanDistance(
        userScore['depression'],
        userScore['anxiety'],
        userScore['stress'],
        room['depression'],
        room['anxiety'],
        room['stress'],
      );

      roomDistances.add({
        'roomId': room['room_id'],
        'id': room['id'],
        'name': room['name'],
        'anonymous': room['anonymous'],
        'imageUrl': room['imageUrl'],
        'emotion': room['emotion'],
        'distance': distance,
      });
    }

    // Sort rooms based on the distance in ascending order
    roomDistances.sort((a, b) => a['distance'].compareTo(b['distance']));

    // Return the top 5 closest rooms
    return roomDistances.take(5).toList();
  }

  double calculateEuclideanDistance(
      int dep1, int anx1, int str1, int dep2, int anx2, int str2) {
    return sqrt(
        pow(dep1 - dep2, 2) + pow(anx1 - anx2, 2) + pow(str1 - str2, 2));
  }
}
