import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/features/chatbot/chatbot_page.dart';
import 'package:lingap/screens/splashscreen.dart';
import 'package:lingap/screens/intro_page.dart';
import 'package:lingap/screens/bottom_nav.dart';
import 'package:lingap/screens/home_page.dart';
import 'package:lingap/screens/login_page.dart';
import 'package:lingap/features/peer_communication/logic/chat_logic.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/intro',
        builder: (context, state) => const IntroPage(),
      ),
      GoRoute(
        path: '/bottom-nav',
        builder: (context, state) => const BottomNav(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => SignInPage(),
      ),
      GoRoute(
        path: '/chatbot',
        builder: (context, state) => ChatbotPage(),
      ),

      
    ],
  );
});
