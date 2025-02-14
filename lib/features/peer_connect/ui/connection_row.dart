import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class ConnectionRow extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final VoidCallback onTap; // Callback for tapping the entire row

  const ConnectionRow({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.onTap, // Pass the onTap callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        color: Colors.transparent, // Ensures the entire row is tappable
        child: Row(
          children: [
            // Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white, // White border
                  width: 3.0, // Border width
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: ClipOval(
                  child: Image.asset(
                    avatarUrl,
                    fit: BoxFit.cover,
                    width: 50, // Match the diameter of the CircleAvatar
                    height: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: mindfulBrown['Brown80'],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // High Five Icon
            IconButton(
              icon: Icon(
                Icons.waving_hand,
                color: zenYellow['Yellow50'],
                size: 30,
              ),
              onPressed: () {
                // Add action for the high five button here
                print('High five pressed for $name');
              },
            ),
          ],
        ),
      ),
    );
  }
}
