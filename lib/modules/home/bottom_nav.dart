import 'package:flutter/material.dart';
import 'package:lingap/core/utils/test/das_test.dart';
import 'package:lingap/features/virtual_consultation/user/user_page.dart';
import 'package:lingap/modules/home/home_page.dart';
import 'package:lingap/features/chatbot/chatbot_page.dart';
import 'package:lingap/features/journaling/journal_page.dart';
import 'package:lingap/features/peer_connect/peer_page.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  late GlobalSupabase _supabase;
  late SupabaseClient _client;

  @override
  void initState() {
    super.initState();
    _client = Supabase.instance.client;
    _supabase = GlobalSupabase(_client);
    _checkFetchIdStatus();
  }

  void _checkFetchIdStatus() async {
    bool? fetchIdStatus =
        await _supabase.fetchMhScore(_client.auth.currentUser!.id);
    if (!fetchIdStatus!) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DASTest()),
      );
    }
  }

  List<Widget> _screens() {
    return [
      // BluetoothScanPage(),
      HomePage(),
      ChatbotPage(),
      JournalPage(),
      UserPage(),
      PeerConnectPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens()[_currentIndex],
      // Stack(
      //   children: [
      //     // Main content
      //     Positioned.fill(
      //       child: _screens()[_currentIndex],
      //     ),
      //     // Expandable top navigation
      //     Positioned(
      //       top: 0,
      //       left: 0,
      //       right: 0,
      //       child: ExpandableTopNav(),
      //     ),
      //   ],
      // ),
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 600),
        backgroundColor: Color(0xFFEBE7E4),
        color: Colors.white,
        buttonBackgroundColor: Color(0xFF3d4456),
        height: 60,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Color(0xFFd9d9d9)),
          Icon(Icons.chat, size: 30, color: Color(0xFFd9d9d9)),
          Icon(Icons.book, size: 30, color: Color(0xFFd9d9d9)),
          Icon(Icons.person, size: 30, color: Color(0xFFd9d9d9)),
          Icon(Icons.people, size: 30, color: Color(0xFFd9d9d9)),
        ],
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
