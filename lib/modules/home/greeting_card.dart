import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/services/database/global_supabase.dart';

class GreetingCard extends StatefulWidget {
  // final Map<String, dynamic> profile;
  final GlobalKey keyGreeting;
  final GlobalKey keyNotification;
  final GlobalKey keySetting;
  final String name;
  final String imageUrl;

  const GreetingCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.keyNotification,
    required this.keySetting,
    required this.keyGreeting,
  }) : super(key: key);

  @override
  _GreetingCardState createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final GlobalSupabase supabase = GlobalSupabase(client);
  ui.Image? _backgroundImage;
  Map<String, dynamic>? profile;
  late Map<String, dynamic> selectedSuggestion;
  int notificationValue = 0;
  final List<Map<String, dynamic>> featureSuggestions = [
    {
      'message':
          "Feeling overwhelmed? The chatbot is here to listen and support you.",
      'button': "Talk to Ligaya",
      'location': '/bottom-nav',
      'extra': 1,
      'color': mindfulBrown['Brown40']
    },
    {
      'message':
          "Journaling helps clear the mind. Want to write something today?",
      'button': "Start Journaling",
      'location': '/bottom-nav',
      'extra': 2,
      'color': zenYellow['Yellow50']
    },
    {
      'message':
          "Need professional advice? You can talk to a licensed mental health practitioner.",
      'button': "Book a Consultation",
      'location': '/bottom-nav',
      'extra': 3,
      'color': empathyOrange['Orange50']
    },
    {
      'message':
          "Would you like to talk to someone who understands? Connect with a peer now.",
      'button': "Find a Peer",
      'location': '/bottom-nav',
      'extra': 4,
      'color': serenityGreen['Green50']
    },
    {
      'message':
          "Let’s take a deep breath. A short mindfulness exercise could help today.",
      'button': "Start Exercise",
      'location': '/mindful-home',
      'extra': 0,
      'color': reflectiveBlue['Blue50']
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();

    _fetchProfile();
    selectedSuggestion =
        featureSuggestions[Random().nextInt(featureSuggestions.length)];
    fetchNotification();
  }

  Future<void> fetchNotification() async {
    final result = await supabase.fetchNotificationValue();
    setState(() {
      notificationValue = result;
    });
  }

  Future<void> _fetchProfile() async {
    Map<String, dynamic>? result = await supabase.fetchProfile(uid);
    if (mounted) {
      setState(() {
        profile = result;
        profileConst = result!;
      });
    }
  }

  Future<void> _loadBackgroundImage() async {
    final image = await preloadImage('assets/profileIcon/bg.png');
    if (mounted) {
      setState(() {
        _backgroundImage = image;
        bgCons = image;
      });
    }
  }

  Future<ui.Image> preloadImage(String assetPath) async {
    final data = await DefaultAssetBundle.of(context).load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  Widget build(BuildContext context) {
    // Get the current date formatted as "January 15, 2025"
    final currentDate = DateFormat('MMMM d, yyyy').format(DateTime.now());
    final String username = (() {
      // Split the name at spaces
      final List<String> parts = widget.name.split(' ');

      // Get the first two items if they exist
      final String firstName = parts.isNotEmpty ? parts[0] : '';
      final String secondName = parts.length > 1 ? parts[1] : '';

      // Combine the first two names
      final String combined = '$firstName $secondName';

      // Return the username based on the length condition
      if (combined.length <= 11) {
        return combined;
      } else {
        return firstName;
      }
    })();

    return Center(
      child: Container(
        key: widget.keyGreeting,
        width: double.infinity,
        decoration: BoxDecoration(
          color: mindfulBrown['Brown80'],
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  key: widget.keySetting,
                  onTap: () {
                    context.push('/profile',
                        extra: {'bg': _backgroundImage, 'profile': profile});
                  },
                  child: Image.asset(
                    'assets/utils/gearSettings.png',
                    width: 20,
                    height: 20,
                  ),
                ),
                // Text(
                //   'Lingap',
                //   style: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.w700,
                //     color: Colors.white,
                //   ),
                // ),
                Stack(
                  children: [
                    IconButton(
                      key: widget.keyNotification,
                      icon: Icon(Icons.notifications),
                      color: Colors.white,
                      onPressed: () {
                        // NOTIFICATION FUNCTION
                        context.push('/notification');
                      },
                    ),
                    if (notificationValue != 0)
                      Positioned(
                        right: 10,
                        top: 10,
                        child: CircleAvatar(
                          radius: 8, // Slightly increased for better visibility
                          backgroundColor: empathyOrange['Orange50'],
                          child: Center(
                            // Ensure text is centered both vertically and horizontally
                            child: Text(
                              notificationValue.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: SizedBox(
                    height: 80,
                    child: Image.asset(widget.imageUrl),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $username!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        selectedSuggestion['message']!,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  context.push(selectedSuggestion['location'],
                      extra: selectedSuggestion['extra']);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedSuggestion['color'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  selectedSuggestion['button'],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String label, String assetPath) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Handle emoji button click
            print('$label clicked');
          },
          child: Image.asset(
            assetPath,
            height: 40, // Adjust icon size
            width: 40,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ],
    );
  }
}
