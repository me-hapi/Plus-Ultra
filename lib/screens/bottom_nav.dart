import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:lingap/screens/home_page.dart';
import 'package:lingap/features/chatbot/chatbot_page.dart';
import 'package:lingap/features/journaling/journal_page.dart';
import 'package:lingap/features/peer_communication/peer_page.dart';
import 'package:lingap/features/virtual_consultation/consultation_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _screens() {
    return [
      HomePage(),
      ChatbotPage(),
      JournalPage(),
      PeerConnectPage(),
      ConsultationPage(),
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
