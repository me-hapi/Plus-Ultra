import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//CHATBOT
import 'package:lingap/features/chatbot/ui/chat_screen.dart' as chatbot_screen;
import 'package:lingap/features/chatbot/ui/landing_page.dart';

//JOURNALING
import 'package:lingap/features/journaling/ui/journal_collection.dart';
import 'package:lingap/features/journaling/ui/journal_detail.dart';
import 'package:lingap/features/journaling/ui/journal_insights.dart';
import 'package:lingap/features/journaling/ui/journal_stat.dart';
import 'package:lingap/features/journaling/ui/journal_success.dart';

//PROFESSIONAL TELECONSULT
import 'package:lingap/features/virtual_consultation/professional/ui/application_page.dart';

//USER TELECONSULT
import 'package:lingap/features/virtual_consultation/user/ui/home_page.dart'
    as user_home;
import 'package:lingap/features/virtual_consultation/user/ui/landing_page.dart';
import 'package:lingap/features/virtual_consultation/user/ui/profile_page.dart'
    as professional_profile;

//WEARABLE
import 'package:lingap/features/wearable_device/ui/health_page.dart';

//PEER TO PEER
import 'package:lingap/features/peer_connect/ui/chat_screen.dart' as peer_screen;

//GENERAL MODULE
import 'package:lingap/modules/profile/ui/profile_page.dart' as module_profile;
import 'package:lingap/modules/sign-in/otp_setup.dart';
import 'package:lingap/modules/splashscreen/get_started.dart';
import 'package:lingap/modules/splashscreen/introduction.dart';
import 'package:lingap/modules/sign-in/signin_page.dart';
import 'package:lingap/modules/sign-in/signup_page.dart';
import 'package:lingap/modules/splashscreen/splashscreen.dart';
import 'package:lingap/modules/home/bottom_nav.dart';
import 'package:lingap/modules/home/home_page.dart' as module_home;
import 'package:lingap/modules/pretest/assessment.dart';
import 'package:lingap/modules/pretest/data_privacy.dart';
import 'package:lingap/core/utils/test/das_result.dart';
import 'package:lingap/core/utils/test/das_test.dart';
import 'package:lingap/core/utils/test/test_intro.dart';

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
        path: '/otpsetup',
        builder: (context, state) {
          final email = state.extra as String?;
          if (email == null) {
            throw Exception('Email is required');
          }
          return OTPSetupPage(email: email);
        },
      ),
      GoRoute(
        path: '/data',
        builder: (context, state) => DataPrivacyScreen(),
      ),
      GoRoute(
        path: '/assessment',
        builder: (context, state) => AssessmentScreen(),
      ),

      GoRoute(
        path: '/test-intro',
        builder: (context, state) => TestIntro(),
      ),

      GoRoute(
          path: '/profile',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;

            return module_profile.ProfilePage(
              backgroundImage: extra['bg'],
              profile: extra['profile'],
            );
          }),
      GoRoute(
        path: '/dastest',
        builder: (context, state) => DASTest(),
      ),
      GoRoute(
        path: '/dasresult',
        builder: (context, state) {
          // Retrieve the extra parameters
          final extra = state.extra as Map<String, int>;

          // Handle null or missing extra parameters
          final depression = extra['depression'] ?? 0;
          final anxiety = extra['anxiety'] ?? 0;
          final stress = extra['stress'] ?? 0;

          return DasResultPage(
            depressionAmount: depression,
            anxietyAmount: anxiety,
            stressAmount: stress,
          );
        },
      ),

      // CHATBOT FEATURE
      GoRoute(
        path: '/chatscreen',
        builder: (context, state) {
          final extra = state.extra as Map;
          final animate = extra['animate'];
          final sessionID = extra['sessionID'];
          return chatbot_screen.ChatScreen(sessionID: sessionID, animateText: animate);
        },
      ),

      GoRoute(
        path: '/chatbot-landing',
        builder: (context, state) => ChatbotLanding(),
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
        path: '/findpage',
        builder: (context, state) => user_home.HomePage(),
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

      //WEARABLE
      GoRoute(
        path: '/health-page',
        builder: (context, state) => HealthPage(),
      ),

      //JOURNALING
      GoRoute(
        path: '/journal-stats',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return JournalStatPage(
              skipCount: extra['skip'],
              negativeCount: extra['negative'],
              positiveCount: extra['positive']);
        },
      ),

      GoRoute(
        path: '/journal-insight',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return JournalInsightPage(
              currentStreak: extra['current'], recordStreak: extra['record']);
        },
      ),

      GoRoute(
        path: '/journal-collection',
        builder: (context, state) {
          final extra = state.extra as List<Map<String, dynamic>>;
          return JournalCollection(dates: extra);
        },
      ),
      GoRoute(
        path: '/journal-success',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return JournalSuccessPage(
              emotion: extra['emotion'],
              date: extra['date'],
              time: extra['time'],
              title: extra['title'],
              journalItems: extra['journalItems']);
        },
      ),

      GoRoute(
        path: '/journal-details',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return JournalDetailPage(
              emotion: extra['emotion'],
              date: extra['date'],
              time: extra['time'],
              title: extra['title'],
              journalItems: extra['journalItems']);
        },
      ),

      //PEER TO PEER 
      GoRoute(
        path: '/peer-chatscreen',
        builder: (context, state) {
          final extra = state.extra as Map;
          final id = extra['id'];
          final roomId = extra['roomId'];
          return peer_screen.ChatScreen(roomId: roomId, id: id);
        },
      ),
    ],
  );
});
