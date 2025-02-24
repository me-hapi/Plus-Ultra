import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/chatbot/data/supabase_db.dart';
import 'package:lingap/features/chatbot/ui/homepage.dart';
import 'package:lingap/features/chatbot/ui/landing_page.dart';
import 'package:lingap/features/virtual_consultation/professional/professional_page.dart';
import 'package:lingap/features/virtual_consultation/user/user_page.dart';
import 'package:lingap/modules/home/home_page.dart';
import 'package:lingap/features/chatbot/chatbot_page.dart';
import 'package:lingap/features/journaling/journal_page.dart';
import 'package:lingap/features/peer_connect/peer_page.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;
  const BottomNav({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late int _currentIndex;
  final SupabaseDB supabase = SupabaseDB(client);
  bool hasSession = false;
  bool _isProfessionalOn = false;
  final GlobalSupabase globalSupabase = GlobalSupabase(client);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    hasConversation();
    _loadProfessionalStatus();
  }

  Future<void> _loadProfessionalStatus() async {
    final result = await globalSupabase.isProfessional(uid);
    if (result) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _isProfessionalOn = prefs.getBool('isProfessional') ?? false;
        professional = _isProfessionalOn;
        print('PROFESSIONAL: $professional');
      });
    } else{
       professional = false;
    }
  }

  void hasConversation() async {
    bool result = await supabase.hasSession(uid);
    if (result) {
      hasSession = result;
    }
  }

  List<Widget> _screens() {
    return [
      HomePage(),
      hasSession ? ChatHome() : ChatbotLanding(),
      JournalPage(),
      professional ? ProfessionalPage() : UserPage(),
      PeerConnectPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens()[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 600),
        backgroundColor: mindfulBrown['Brown10']!,
        color: Colors.white,
        buttonBackgroundColor: optimisticGray['Gray30'],
        height: 60,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: _currentIndex == 0
                ? mindfulBrown['Brown80']
                : optimisticGray['Gray30'],
          ),
          Icon(
            Icons.chat,
            size: 30,
            color: _currentIndex == 1
                ? mindfulBrown['Brown80']
                : optimisticGray['Gray30'],
          ),
          Icon(
            Icons.book,
            size: 30,
            color: _currentIndex == 2
                ? mindfulBrown['Brown80']
                : optimisticGray['Gray30'],
          ),
          Icon(
            Icons.person,
            size: 30,
            color: _currentIndex == 3
                ? mindfulBrown['Brown80']
                : optimisticGray['Gray30'],
          ),
          Icon(
            Icons.people,
            size: 30,
            color: _currentIndex == 4
                ? mindfulBrown['Brown80']
                : optimisticGray['Gray30'],
          ),
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
