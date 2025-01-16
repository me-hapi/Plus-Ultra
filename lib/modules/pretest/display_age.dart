import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class DisplayAge extends StatefulWidget {
  final Function(int) onAgeSelected; // Callback to pass the selected age back to parent

  const DisplayAge({Key? key, required this.onAgeSelected}) : super(key: key);

  @override
  _DisplayAgeState createState() => _DisplayAgeState();
}

class _DisplayAgeState extends State<DisplayAge> {
  int selectedAge = 18; // Default starting age
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: selectedAge - 1); // Set the initial scroll position
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800, // Height for the scrollable number picker
      child: ListWheelScrollView.useDelegate(
        controller: _controller, // Pass the controller to the ListWheelScrollView
        itemExtent: 140, // Space between each item
        onSelectedItemChanged: (index) {
          setState(() {
            selectedAge = index + 1; // Adjust for 1-based age
            widget.onAgeSelected(selectedAge); // Pass selected age to parent
          });
        },
        physics: FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            // Display a limited range around selectedAge (e.g., 25-29)
            final age = index + 1;
            if (age < selectedAge - 2 || age > selectedAge + 2) {
              return null; // Only show ages within the range of selectedAge - 2 to selectedAge + 2
            }

            final isSelected = age == selectedAge;
            final sizeFactor = isSelected
                ? 1.2
                : (age - selectedAge).abs() == 1
                    ? 0.7
                    : 0.5;

            return Center(
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? serenityGreen['Green50'] : Colors.transparent,
                  borderRadius: BorderRadius.circular(100), // Elongated circle effect
                  border: Border.all(
                    color: isSelected ? optimisticGray['Gray20']! : Colors.transparent,
                    width: 7,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "$age",
                  style: TextStyle(
                    fontSize: 75 * sizeFactor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : optimisticGray['Gray60'],
                  ),
                ),
              ),
            );
          },
          childCount: 100, // Number of ages to display, but we are limiting visible ones
        ),
      ),
    );
  }
}
