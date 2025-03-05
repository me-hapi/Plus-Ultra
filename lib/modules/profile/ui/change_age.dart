import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/const/custom_button.dart';
import 'package:lingap/core/const/loading_screen.dart';
import 'package:lingap/features/peer_connect/ui/loading_page.dart';
import 'package:lingap/modules/profile/data/supabase_db.dart';

class ChangeAge extends StatefulWidget {
  const ChangeAge({Key? key}) : super(key: key);

  @override
  _ChangeAgeState createState() => _ChangeAgeState();
}

class _ChangeAgeState extends State<ChangeAge> {
  late FixedExtentScrollController _controller;
  int selectedAge = 25;
  final SupabaseDb _supabaseDb = SupabaseDb();

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: selectedAge - 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mindfulBrown['Brown10'],
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              'Select Age',
              textAlign: TextAlign.center,
              style: TextStyle(color: mindfulBrown['Brown80'], fontSize: 32),
            ),
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: Center(
                child: ListWheelScrollView.useDelegate(
                  controller: _controller,
                  itemExtent: 140,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedAge = index + 1;
                    });
                  },
                  physics: FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final age = index + 1;
                      if (age < selectedAge - 2 || age > selectedAge + 2) {
                        return null;
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
                            color: isSelected
                                ? serenityGreen['Green50']
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: isSelected
                                  ? optimisticGray['Gray20']!
                                  : Colors.transparent,
                              width: 7,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            "$age",
                            style: TextStyle(
                              fontSize: 75 * sizeFactor,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : optimisticGray['Gray60'],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: 100,
                  ),
                ),
              ),
            ),

            CustomButton(
              text: 'Change',
              onPressed: () async {
                LoadingScreen.show(context);
                await _supabaseDb.updateAge(selectedAge);
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
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16),
            //   child: SizedBox(
            //     height: 55,
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       onPressed: () async {
            //         LoadingScreen.show(context);
            //         await _supabaseDb.updateAge(selectedAge);
            //         final profile = await _supabaseDb.fetchProfile();

            //         LoadingScreen.hide(context);
            //         context.go('/bottom-nav');
            //         Future.microtask(() {
            //           context.push('/profile', extra: {
            //             'bg': bgCons,
            //             'profile': profile
            //           }); // Adds Profile on top of Home
            //         });
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: mindfulBrown['Brown80'],
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(30),
            //         ),
            //       ),
            //       child: const Text(
            //         'Change age',
            //         style: TextStyle(
            //           fontSize: 18,
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 15,
            )
          ],
        ));
  }
}
