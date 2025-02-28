import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class ChatRow extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String lastMessage;
  final String time;
  final bool read;
  final bool isUserSender;
  final VoidCallback onTap; // Add onTap callback

  const ChatRow({
    Key? key,
    required this.isUserSender,
    required this.avatarUrl,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.onTap,
    required this.read, // Pass the onTap callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('READ: $read \n USER: $isUserSender');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Use a Container to ensure the full width is clickable
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        color: Colors.transparent, // Ensure the container is transparent
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
            // Name and Last Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: (read == false && isUserSender == false)
                          ? FontWeight.w700
                          : FontWeight.w300,
                      fontSize: 16,
                      color: mindfulBrown['Brown80'],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: TextStyle(
                      color: (read == false && isUserSender == false)
                          ? mindfulBrown['Brown80']
                          : optimisticGray['Gray50'],
                      fontSize: 14,
                      fontWeight: read ? FontWeight.w300 : FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Time and Unread Messages
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                if (read && isUserSender)
                  SizedBox(
                      height: 15,
                      width: 15,
                      child: CircleAvatar(
                        backgroundColor: optimisticGray['Gray30'],
                        child: Image.asset(
                          'assets/utils/whiteCheck.png',
                          width: 12,
                          height: 12,
                        ),
                      ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
