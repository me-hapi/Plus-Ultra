import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class IssuesRow extends StatelessWidget {
  final Map<String, String> issues;
  final String? selectedIssue;
  final Function(String) onIssueSelected;

  const IssuesRow({
    Key? key,
    required this.issues,
    this.selectedIssue,
    required this.onIssueSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: issues.entries.map((entry) {
          bool isSelected = entry.key == selectedIssue;

          return GestureDetector(
            onTap: () => onIssueSelected(entry.key),
            child: Container(
              padding: EdgeInsets.all(6),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor:  isSelected ? serenityGreen['Green50'] : Colors.transparent,
                    child: Image.asset(entry.value, width: 65, height: 65),
                  ),
                  Text(entry.key, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
