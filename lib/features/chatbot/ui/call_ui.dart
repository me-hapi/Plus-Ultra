import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/chatbot/services/call_logic.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CallChatbot extends StatefulWidget {
  final int sessionID;

  const CallChatbot({super.key, required this.sessionID});

  @override
  _CallChatbotState createState() => _CallChatbotState();
}

class _CallChatbotState extends State<CallChatbot> {
  late CallLogic _callLogic;
  bool _isMuted = false;
  bool _isMicActive = false;
  late Timer _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _callLogic = CallLogic(widget.sessionID);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callLogic.playIntro(() => setState(() {}));
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when widget is disposed
     _callLogic.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: serenityGreen['Green50'],
      appBar: AppBar(
        title: Text(
          "Ligaya",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: serenityGreen['Green50'],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _callLogic.displayedText,
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMuted = !_isMuted;
                      _callLogic.setMute(_isMuted);
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mindfulBrown['Brown80'],
                    ),
                    child: Center(
                      child: Icon(
                        _isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      _formatTime(_secondsElapsed), // Updated to display timer
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: empathyOrange['Orange50']),
                        child: Center(
                          child: Image.asset(
                            'assets/peer/call.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMicActive = !_isMicActive;
                      if (mounted) {
                        // if (_isMicActive) {
                        //   _callLogic.startListening(() => setState(() {}));
                        // } else {
                        //   _callLogic.stopListening(() => setState(() {}));
                        // }
                        _callLogic.startListening(() => setState(() {}));
                      }
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mindfulBrown['Brown80'],
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.mic,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
