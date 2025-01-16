import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class DisplayWeight extends StatefulWidget {
  final Function(double, String)
      onWeightSelected; // Callback to pass the weight and unit to the parent

  const DisplayWeight({Key? key, required this.onWeightSelected})
      : super(key: key);

  @override
  _DisplayWeightState createState() => _DisplayWeightState();
}

class _DisplayWeightState extends State<DisplayWeight> {
  double selectedWeight = 60; // Default weight
  String unit = 'kg'; // Default unit
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: selectedWeight * 20, // Set initial position
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Convert between kg and lbs
  double convertWeight(double weight, String fromUnit, String toUnit) {
    return fromUnit == toUnit
        ? weight
        : (fromUnit == 'kg' ? weight * 2.20462 : weight / 2.20462);
  }

  // Handle scroll event
  void _onScroll() {
    final middleOffset =
        _scrollController.offset + (MediaQuery.of(context).size.width / 2 - 20);
    final weight = (middleOffset / 20).round().toDouble();
    if (weight != selectedWeight) {
      setState(() {
        selectedWeight = weight.clamp(0, 400);
        widget.onWeightSelected(selectedWeight, unit);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 70,
            ),
            // Toggle for kg and lbs
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 5), // Add padding for the rectangle
              decoration: BoxDecoration(
                color: mindfulBrown[
                    'Brown20'], // Background color for the rectangle
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (unit != 'kg') {
                          selectedWeight =
                              convertWeight(selectedWeight, 'lbs', 'kg');
                          unit = 'kg';
                        }
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 76, vertical: 15),
                      decoration: BoxDecoration(
                        color: unit == 'kg'
                            ? Colors.white
                            : mindfulBrown['Brown20'],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'kg',
                        style: TextStyle(
                          color: unit == 'kg'
                              ? mindfulBrown['Brown80']
                              : mindfulBrown['Brown60'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (unit != 'lbs') {
                          selectedWeight =
                              convertWeight(selectedWeight, 'kg', 'lbs');
                          unit = 'lbs';
                        }
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 76, vertical: 15),
                      decoration: BoxDecoration(
                        color: unit == 'lbs'
                            ? Colors.white
                            : mindfulBrown['Brown20'],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'lbs',
                        style: TextStyle(
                          color: unit == 'lbs'
                              ? mindfulBrown['Brown80']
                              : mindfulBrown['Brown60'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 50),
            // Display the selected weight
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedWeight.toStringAsFixed(0),
                  style: TextStyle(
                      color: mindfulBrown['Brown80'],
                      fontSize: 120,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  unit,
                  style: TextStyle(
                      color: optimisticGray['Gray60'],
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // Rolling horizontal weight selector
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 401, // For weights 0 to 400
                itemExtent: 20, // Space for each line
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final isDivisibleByFive = index % 5 == 0;
                  final isSelected = index == selectedWeight.toInt();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 6,
                        height: isSelected
                            ? 0 // Black line disappears for the selected weight
                            : isDivisibleByFive
                                ? 80
                                : 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? null
                              : isDivisibleByFive
                                  ? optimisticGray['Gray40']
                                  : optimisticGray['Gray30'],
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      SizedBox(height: 5),
                      if (isDivisibleByFive && !isSelected)
                        Text(
                          index.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: optimisticGray['Gray40'],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
        // Green middle line
        Positioned(
          bottom: 100, // Position the green line at the middle vertically
          left: MediaQuery.of(context).size.width / 2 -
              20, // Center it horizontally
          child: Container(
            width: 18,
            height: 120,
            decoration: BoxDecoration(
              color: serenityGreen['Green50'], // Background color
              borderRadius: BorderRadius.circular(30), // Rounded corners
              border: Border.all(
                color: serenityGreen['Green20']!, // Border color
                width: 4, // Border thickness
              ),
            ),
          ),
        ),
      ],
    );
  }
}
