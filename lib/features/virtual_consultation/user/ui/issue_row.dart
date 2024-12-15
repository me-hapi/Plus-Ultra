import 'package:flutter/material.dart';

class IssuesRow extends StatelessWidget {
  final Map<String, String> issues;

  const IssuesRow({
    Key? key,
    required this.issues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: issues.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(
              width: 70, // Fixed width for uniform size
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[350], // Gray color for the frame
                        ),
                      ),
                      ClipOval(
                        child: Image.asset(
                          entry.value,
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.key,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF473c38),
                    ),
                    maxLines: 2, // Limit to two lines to handle longer text
                    overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
