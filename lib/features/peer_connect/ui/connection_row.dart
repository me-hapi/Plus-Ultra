import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        color: Colors.transparent, // Ensures the entire row is tappable
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 12),
            // Name
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // High Five Icon
            IconButton(
              icon: const Icon(
                Icons.emoji_emotions,
                color: Colors.blueGrey,
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
