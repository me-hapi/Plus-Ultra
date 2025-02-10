import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/chatbot/logic/chatbot_manager.dart';
import 'package:lingap/features/chatbot/ui/chat_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final int sessionID;
  final bool animateText;
  final bool? intro;
  bool isSessionOpen;

  ChatScreen(
      {super.key,
      required this.sessionID,
      required this.animateText,
      required this.isSessionOpen,
      this.intro});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final Set<int> _animatedMessageIndexes = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatbotProvider(widget.sessionID).notifier).introduction();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateSessionState(bool isOpen) {
    setState(() {
      widget.isSessionOpen = isOpen;
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatbotProvider(widget.sessionID));

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mindfulBrown['Brown80'],
        toolbarHeight: 50.0,
        title: Text('AI Chat',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/peer/call.png',
              width: 20,
              height: 20,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(10.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                bool shouldAnimate = !_animatedMessageIndexes.contains(index);

                return ChatBubble(
                  animateText:
                      widget.animateText ? shouldAnimate : widget.animateText,
                  isUser: message.isUser,
                  message: message.message,
                  onTextUpdate: _scrollToBottom,
                  emotion: message.emotion,
                  onCompleted: () {
                    // Ensure that this is only triggered once per message.
                    if (!_animatedMessageIndexes.contains(index)) {
                      _animatedMessageIndexes.add(index);

                      switch (message.emotion.toLowerCase()) {
                        case 'progress':
                          print(message.emotion.toLowerCase());
                          ref
                              .read(chatbotProvider(widget.sessionID).notifier)
                              .postAssessment();
                          break;

                        case 'script':
                          ref
                              .read(chatbotProvider(widget.sessionID).notifier)
                              .askQuestion();
                          break;

                        case 'dass':
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ref
                                .read(
                                    chatbotProvider(widget.sessionID).notifier)
                                .sendOption();
                          });
                          break;

                        case 'interpretation':
                          ref
                              .read(chatbotProvider(widget.sessionID).notifier)
                              .askSession();
                          break;

                        default:
                          break;
                      }
                    }
                  },
                  onOptionSelected: (selectedOption) {
                    if (message.emotion.toLowerCase() == 'option') {
                      ref
                          .read(chatbotProvider(widget.sessionID).notifier)
                          .getScore(selectedOption);
                    }

                    if (message.emotion.toLowerCase() == 'close') {
                      ref
                          .read(chatbotProvider(widget.sessionID).notifier)
                          .checkSession(selectedOption);

                      if (selectedOption.toLowerCase() == "oo") {
                        _updateSessionState(
                            false); // Close session when "Oo" is selected
                      }
                    }
                  },
                );
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.isSessionOpen
                  ? _buildInputField(context)
                  : const Center(
                      child: Text(
                        'Session Ended',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: ref
                .read(chatbotProvider(widget.sessionID).notifier)
                .messageController,
            decoration: InputDecoration(
              hintText: 'Type a message',
              hintStyle: TextStyle(
                color: mindfulBrown['Brown80'],
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: serenityGreen['Green30']!,
                  width: 2.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
            ),
            style: TextStyle(
              color: mindfulBrown['Brown80'],
            ),
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            ref.read(chatbotProvider(widget.sessionID).notifier).sendMessage();
            _scrollToBottom(); // Scroll to bottom after sending
          },
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: serenityGreen['Green50'],
            ),
            child: Center(
              child: Image.asset(
                'assets/peer/send.png',
                width: 20.0,
                height: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
