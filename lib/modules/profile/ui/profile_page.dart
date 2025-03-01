import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/utils/shared/shared_pref.dart';

import 'package:lingap/features/virtual_consultation/professional/ui/application_page.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/steps/successful_modal.dart';
import 'package:lingap/modules/home/bottom_nav.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final ui.Image backgroundImage;
  final Map<String, dynamic> profile;

  const ProfilePage(
      {Key? key, required this.backgroundImage, required this.profile})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isNotificationOn = false;
  bool _Anonymous = false;
  bool _isSigningOut = false;
  GlobalSupabase supabase = GlobalSupabase(client);
  bool _isProfessionalOn = false;
  bool isProfessional = false;

  @override
  void initState() {
    super.initState();
    _checkProfessionalStatus();
    _loadProfessionalStatus();
    _loadAnonymousStatus();
  }

  void _checkProfessionalStatus() async {
    bool result = await supabase.isProfessional(uid);
    setState(() {
      isProfessional = result;
    });
  }

  Future<void> _loadProfessionalStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isProfessionalOn = prefs.getBool('isProfessional') ?? false;
      professional = _isProfessionalOn;
    });
  }

  Future<void> _updateProfessionalStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isProfessional', value);
    setState(() {
      _isProfessionalOn = value;
      professional = _isProfessionalOn;
    });
  }

  Future<void> _loadAnonymousStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _Anonymous = prefs.getBool('isAnonymous') ?? false;
      isAnonymous = _Anonymous;
    });
  }

  Future<void> _updateAnonymousStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAnonymous', value);
    setState(() {
      _Anonymous = value;
      isAnonymous = _Anonymous;
    });
  }

  Future<void> _signOut() async {
    setState(() {
      _isSigningOut = true;
    });

    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        context.go('/signin');
      }
    } catch (e) {
      setState(() {
        _isSigningOut = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String weight = widget.profile['weight'].toString();
    String unit = widget.profile['weight_lbl'];
    String weight_unit = '$weight $unit';
    return Scaffold(
      backgroundColor: mindfulBrown['Brown10'],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip
                  .none, // Ensures children can overflow the bounds of the Stack
              children: [
                CustomPaint(
                  painter: ConvexArcPainter(widget.backgroundImage!),
                  child: Container(
                    height: 250, // Height of the arc
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 30,
                          left: 10,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Positioned(
                          top: 40, // Move text higher
                          child: Text(
                            'My Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 200, // Adjust to overlap the arc
                  left: 0,
                  right: 0,
                  child: Center(
                      child: SizedBox(
                    height: 100,
                    child: Image.asset(widget.profile['imageUrl']),
                  )),
                ),
              ],
            ),

            const SizedBox(height: 60), // Space below the avatar
            Text(
              widget.profile['name'],
              style: TextStyle(
                fontSize: 32,
                color: mindfulBrown['Brown80']!,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    context.push('/change-age');
                  },
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Age',
                          style: TextStyle(
                            fontSize: 14,
                            color: mindfulBrown['Brown80']!,
                            fontWeight: FontWeight.bold,
                          ),
                        ), // Spacing between texts
                        Text(
                          widget.profile['age'].toString(),
                          style: TextStyle(
                            fontSize: 24,
                            color: mindfulBrown['Brown80']!,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 70, // Ensures the divider is sized correctly
                  alignment: Alignment.center, // Centers the divider vertically
                  child: VerticalDivider(
                    color: optimisticGray['Gray50']!,
                    thickness: 2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.push('/change-weight');
                  } ,
                    child: SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Weight',
                        style: TextStyle(
                          fontSize: 14,
                          color: mindfulBrown['Brown80']!,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        weight_unit,
                        style: TextStyle(
                          fontSize: 24,
                          color: mindfulBrown['Brown80']!,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),

            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'General Settings',
                  style: TextStyle(
                    fontSize: 16,
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTile(
                  leading: Image.asset('assets/profileIcon/user.png'),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    'Professional Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mindfulBrown['Brown80'],
                    ),
                  ),
                  trailing: isProfessional
                      ? Switch(
                          value: _isProfessionalOn,
                          onChanged: (value) {
                            _updateProfessionalStatus(value);
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[300],
                        )
                      : ElevatedButton(
                          onPressed: () {
                            context.push('/application_page');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: reflectiveBlue['Blue50'],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Apply",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTile(
                  leading: Image.asset('assets/profileIcon/notification.png'),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    'Notification',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mindfulBrown['Brown80'],
                    ),
                  ),
                  trailing: Switch(
                    value: _isNotificationOn,
                    onChanged: (value) {
                      setState(() {
                        _isNotificationOn = value; // Toggle the switch
                      });
                    },
                    activeColor: Colors.green, // Green when ON
                    inactiveThumbColor: Colors.grey, // Gray thumb when OFF
                    inactiveTrackColor:
                        Colors.grey[300], // Light gray track when OFF
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16),
            //   child: Card(
            //     color: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     child: ListTile(
            //       onTap: () {},
            //       leading: Image.asset('assets/profileIcon/emergency.png'),
            //       contentPadding:
            //           EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //       title: Text(
            //         'Emergency Contact',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: mindfulBrown['Brown80'],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTile(
                  leading: Image.asset('assets/profileIcon/emergency.png'),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    'Anonymous',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mindfulBrown['Brown80'],
                    ),
                  ),
                  trailing: Switch(
                    value: _Anonymous,
                    onChanged: (value) {
                      setState(() {
                        _updateAnonymousStatus(value);
                      });
                    },
                    activeColor: Colors.green, // Green when ON
                    inactiveThumbColor: Colors.grey, // Gray thumb when OFF
                    inactiveTrackColor:
                        Colors.grey[300], // Light gray track when OFF
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Danger Zone',
                  style: TextStyle(
                    fontSize: 16,
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    // showDialog(
                    //   context: context,
                    //   barrierDismissible:
                    //       false, // Prevent closing by tapping outside
                    //   builder: (context) => Dialog(
                    //     backgroundColor: Colors
                    //         .transparent, // Makes dialog background transparent
                    //     child: SuccessfulModal(),
                    //   ),
                    // );
                  },
                  child: Card(
                    color: presentRed['Red20'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ListTile(
                      leading: Image.asset('assets/profileIcon/close.png'),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      title: Text(
                        'Close Account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mindfulBrown['Brown80'],
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: mindfulBrown['Brown80'],
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 16,
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: mindfulBrown['Brown80'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTile(
                  onTap: _signOut,
                  leading: Image.asset('assets/profileIcon/logout.png'),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    'Log out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ConvexArcPainter extends CustomPainter {
  final ui.Image backgroundImage;

  ConvexArcPainter(this.backgroundImage);

  @override
  void paint(Canvas canvas, Size size) {
    // Define the convex arc shape
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 30)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + 30,
        size.width,
        size.height - 30,
      )
      ..lineTo(size.width, 0)
      ..close();

    // Clip the canvas to the convex arc shape
    canvas.clipPath(path);

    // Draw the background image within the clipped path
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      image: backgroundImage,
      fit: BoxFit.cover,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
