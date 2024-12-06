import 'package:flutter/material.dart';
import 'package:lingap/core/utils/test/das_test.dart';
import 'package:lingap/features/wearable_device/bluetooth_scan.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:lingap/screens/home_page.dart';
import 'package:lingap/features/chatbot/chatbot_page.dart';
import 'package:lingap/features/journaling/journal_page.dart';
// import 'package:lingap/features/peer_communication/peer_page.dart';
import 'package:lingap/features/peer_connect/peer_page.dart';
import 'package:lingap/features/virtual_consultation/consultation_page.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
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
    bool? fetchIdStatus = await _supabase.fetchMhScore(_client.auth.currentUser!.id);
    if (!fetchIdStatus!) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DASTest()),
      );
    }
  }

  List<Widget> _screens() {
    return [
      BluetoothScanPage(),
      ChatbotPage(),
      JournalPage(),
      ConsultationPage(),
      PeerConnectPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Color(0xFF86469C),
        inactiveColorPrimary: Color(0xFFFFCDEA),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.chat),
        title: ("Chatbot"),
        activeColorPrimary: Color(0xFF86469C),
        inactiveColorPrimary: Color(0xFFFFCDEA),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Journal"),
        activeColorPrimary: Color(0xFF86469C),
        inactiveColorPrimary: Color(0xFFFFCDEA),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Consultation"),
        activeColorPrimary: Color(0xFF86469C),
        inactiveColorPrimary: Color(0xFFFFCDEA),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Connect"),
        activeColorPrimary: Color(0xFF86469C),
        inactiveColorPrimary: Color(0xFFFFCDEA),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _screens(),
      items: _navBarItems(),
      backgroundColor: Colors.white,
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      navBarStyle: NavBarStyle.style3,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(15.0),
        colorBehindNavBar: Colors.white,
      ),
      confineToSafeArea: true,
      margin: EdgeInsets.all(0.0),
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: kBottomNavigationBarHeight,
      onWillPop: (context) async {
        return true;
      },
    );
  }
}
