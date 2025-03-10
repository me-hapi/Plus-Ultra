import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/chatbot/data/supabase_db.dart';
import 'package:lingap/features/chatbot/ui/landing_tutorial.dart';

class ChatbotLanding extends StatefulWidget {
  const ChatbotLanding({Key? key}) : super(key: key);

  @override
  _ChatbotLandingState createState() => _ChatbotLandingState();
}

class _ChatbotLandingState extends State<ChatbotLanding> {
  final SupabaseDB supabase = SupabaseDB(client);
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Show the tutorial coach mark after the first frame is rendered
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   LandingTutorial.show(context, _buttonKey);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'AI Chatbot',
          style: TextStyle(
              color: mindfulBrown['Brown80'],
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/chatbot/chatbot.png',
                width: 300,
              ),
              const SizedBox(height: 20),
              Text(
                'You have no AI conversations yet. Get your mind healthy by starting a new one',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: mindfulBrown['Brown80']),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    key: _buttonKey,
                    onPressed: () async {
                      int result = await supabase.createSession(uid);
                      if (result != 0) {
                        context.go('/bottom-nav', extra: 1);
                        Future.microtask(() {
                          context.push('/chatscreen', extra: {
                            'animate': true,
                            'sessionID': result,
                            'intro': true,
                            'open': true
                          });
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mindfulBrown['Brown80'],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'New Conversation',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
