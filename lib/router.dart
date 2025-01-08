import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/utils/test/das_test.dart';
import 'package:lingap/features/chatbot/chatbot_page.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/application_page.dart';

//USER TELECONSULT
import 'package:lingap/features/virtual_consultation/user/ui/home_page.dart'
    as user_home;
import 'package:lingap/features/virtual_consultation/user/ui/landing_page.dart';
import 'package:lingap/features/virtual_consultation/user/ui/profile_page.dart'
    as professional_profile;

//GENERAL MODULE
import 'package:lingap/modules/profile/ui/profile_page.dart' as module_profile;
import 'package:lingap/modules/splashscreen/get_started.dart';
import 'package:lingap/modules/splashscreen/introduction.dart';
import 'package:lingap/modules/sign-in/signin_page.dart';
import 'package:lingap/modules/signup/signup_page.dart';
import 'package:lingap/modules/splashscreen/splashscreen.dart';
import 'package:lingap/modules/home/bottom_nav.dart';
import 'package:lingap/modules/home/home_page.dart' as module_home;

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      //General Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/bottom-nav',
        builder: (context, state) {
          final currentIndex = state.extra as int? ?? 0;
          return BottomNav(currentIndex: currentIndex);
        },
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const module_home.HomePage(),
      ),

      GoRoute(
        path: '/get-started',
        builder: (context, state) => GetStartedPage(),
      ),
      GoRoute(
        path: '/introduction',
        builder: (context, state) => IntroductionPage(),
      ),

      GoRoute(
        path: '/signin',
        builder: (context, state) => SignInPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignUpPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => module_profile.ProfilePage(),
      ),
      GoRoute(
        path: '/dastest',
        builder: (context, state) => DASTest(),
      ),

      // CHATBOT FEATURE
      GoRoute(
        path: '/chatbot',
        builder: (context, state) => ChatbotPage(),
      ),

      //VIRTUAL CONSULTATION
      //Professional
      GoRoute(
        path: '/application_page',
        builder: (context, state) => ApplicationPage(),
      ),

      //User
      GoRoute(
        path: '/landing_page',
        builder: (context, state) => LandingPage(),
      ),
      GoRoute(
        path: '/professional_profile',
        builder: (context, state) {
          final professionalData = state.extra as Map<String, dynamic>;
          return professional_profile.ProfilePage(
              professionalData: professionalData);
        },
      ),
      GoRoute(
        path: '/selection_professional',
        builder: (context, state) => user_home.HomePage(),
      ),
    ],
  );
});
