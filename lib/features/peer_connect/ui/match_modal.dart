import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/peer_connect/ui/match_card.dart';

class MatchModal extends StatelessWidget {
  final List<Map<String, dynamic>> matches;

  MatchModal({required this.matches});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: mindfulBrown['Brown10'],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Matches",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          ...matches.map((match) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: MatchCard(
                  avatarUrl: match['imageUrl'] ?? '',
                  name: match['name'] ?? 'Unknown',
                  emotion: match['emotion'] ?? 'Neutral',
                ),
              )),
        ],
      ),
    );
  }
}
