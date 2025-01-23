import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

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
                  Image.asset(
                    entry.value,
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.key,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: mindfulBrown['Brown80'],
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
