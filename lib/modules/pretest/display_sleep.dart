import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class DisplaySleep extends StatefulWidget {
  final Function(String)
      onSleepSelected; // Callback to pass selected sleep quality to the parent

  const DisplaySleep({Key? key, required this.onSleepSelected})
      : super(key: key);

  @override
  _DisplaySleepState createState() => _DisplaySleepState();
}

class _DisplaySleepState extends State<DisplaySleep> {
  int selectedCategory = 2; // Default category (Fair)

  // List of moods corresponding to the sleep categories
  final List<String> moods = [
    'assets/mood/cheerful.png', // Excellent mood
    'assets/mood/happy.png', // Good mood
    'assets/mood/neutral.png', // Fair mood
    'assets/mood/sad.png', // Poor mood
    'assets/mood/awful.png', // Worst mood
  ];

   final List<String> moodString = [
    'Worst', // Excellent mood
    'Poor', // Good mood
    'Fair', // Fair mood
    'Good', // Poor mood
    'Excellent', // Worst mood
  ];

  final List<Color> colors = [
    kindPurple['Purple40']!,
    empathyOrange['Orange40']!,
    mindfulBrown['Brown40']!,
    zenYellow['Yellow40']!,
    serenityGreen['Green40']!,
  ];

  // Categories and corresponding descriptions
  final List<Map<dynamic, dynamic>> categories = [
    {'label': 'Excellent', 'hours': '7-9 hours'},
    {'label': 'Good', 'hours': '6-7 hours'},
    {'label': 'Fair', 'hours': '5 hours'},
    {'label': 'Poor', 'hours': '3-4 hours'},
    {'label': 'Worst', 'hours': '<3 hours'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 30,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // First column with sleep categories
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories
                .map((category) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          category['label'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 24,
                              color: optimisticGray['Gray30'],
                            ),
                            SizedBox(
                                width:
                                    8), // Add some spacing between the icon and the text
                            Text(
                              category['hours'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        )
                      ],
                    ))
                .toList(),
          ),
          SizedBox(width: 20),

          // Second column with the slider
          Column(
            children: [
              RotatedBox(
                quarterTurns:
                    3, // Rotates the slider by 270 degrees to make it vertical
                child: SizedBox(
                  width: 450, // Adjust the height to make the slider longer
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 12, // Set the thickness of the slider track
                      thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 20), // Customize the thumb size
                    ),
                    child: Slider(
                      value: selectedCategory.toDouble(),
                      min: 0,
                      max: 4,
                      divisions: 4,
                      activeColor: colors[selectedCategory],
                      inactiveColor: mindfulBrown['Brown20'],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value.toInt();
                          widget.onSleepSelected(
                              moodString[selectedCategory]); // Pass mood to parent
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 20),

          // Third column with the mood images
          Column(
            children: moods
                .map((mood) => Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          mood,
                          height: 50,
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ))
                .toList(),
          ),
        ],
      )
    ]);
  }
}
