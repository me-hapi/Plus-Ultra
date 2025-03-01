import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/const/loading_screen.dart';
import 'package:lingap/modules/profile/data/supabase_db.dart';

class ChangeWeight extends StatefulWidget {
  const ChangeWeight({Key? key}) : super(key: key);

  @override
  _ChangeWeightState createState() => _ChangeWeightState();
}

class _ChangeWeightState extends State<ChangeWeight> {
  double selectedWeight = 68; // Default weight
  String unit = 'kg'; // Default unit
  late ScrollController _scrollController;
  final SupabaseDb _supabaseDb = SupabaseDb();

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mindfulBrown['Brown10'],
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Select Age',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: mindfulBrown['Brown80'], fontSize: 32),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // Toggle for kg and lbs
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: mindfulBrown[
                            'Brown20'], // Background color for the rectangle
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (unit != 'kg') {
                                  selectedWeight = convertWeight(
                                      selectedWeight, 'lbs', 'kg');
                                  unit = 'kg';
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 75, vertical: 15),
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
                                  selectedWeight = convertWeight(
                                      selectedWeight, 'kg', 'lbs');
                                  unit = 'lbs';
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 75, vertical: 15),
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
                  Spacer(),
                  SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        LoadingScreen.show(context);
                        await _supabaseDb.updateWeight(selectedWeight, unit);
                        final profile = await _supabaseDb.fetchProfile();

                        LoadingScreen.hide(context);
                        context.go('/bottom-nav');
                        Future.microtask(() {
                          context.push('/profile', extra: {
                            'bg': bgCons,
                            'profile': profile
                          }); // Adds Profile on top of Home
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mindfulBrown['Brown80'],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Change weight',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),

            // Green middle line
            Positioned(
              bottom: 150, // Position the green line at the middle vertically
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
        ));
  }
}
