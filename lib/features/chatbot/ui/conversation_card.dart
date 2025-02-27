import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';

class ConversationCard extends StatelessWidget {
  final int sessionID;
  final bool animate;
  final String imagePath;
  final String title;
  final String total;
  final String emotion;
  final bool isSessionOpen;
  final Future<void> Function() onDelete;

  const ConversationCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.total,
    required this.emotion,
    required this.sessionID,
    required this.animate,
    required this.isSessionOpen,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(30), // Rounded corners for dismissable
      child: Dismissible(
        key: Key(sessionID.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: presentRed['Red50'],
            borderRadius: BorderRadius.circular(30), // Matches card rounding
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 30),
        ),
        onDismissed: (direction) {
          onDelete();
        },
        child: GestureDetector(
          onTap: () {
            context.push('/chatscreen', extra: {
              'sessionID': sessionID,
              'animate': false,
              'open': isSessionOpen
            });
          },
          child: Card(
            color: isSessionOpen ? Colors.white : optimisticGray['Gray50'],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Circle Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/chatbot/icon/abstract.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title and Row
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: isSessionOpen
                                ? mindfulBrown['Brown80']
                                : optimisticGray['Gray30'],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              total,
                              style: TextStyle(
                                  color: isSessionOpen
                                      ? optimisticGray['Gray60']
                                      : optimisticGray['Gray30']),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isSessionOpen
                                    ? optimisticGray['Gray60']
                                    : optimisticGray['Gray30'],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              emotion,
                              style: TextStyle(
                                  color: isSessionOpen
                                      ? optimisticGray['Gray60']
                                      : optimisticGray['Gray30']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color:
                        isSessionOpen ? optimisticGray['Gray50'] : Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
