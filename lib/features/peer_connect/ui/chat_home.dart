import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/utils/security/encryption.dart';
import 'package:lingap/features/peer_connect/data/supabase_db.dart';
import 'package:lingap/features/peer_connect/services/api_service.dart';
import 'package:lingap/features/peer_connect/ui/chat_rows.dart';
import 'package:lingap/features/peer_connect/ui/chat_screen.dart';
import 'package:lingap/features/peer_connect/ui/connection_row.dart';
import 'package:lingap/features/peer_connect/ui/loading_page.dart';

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final SupabaseDB _supabaseDb = SupabaseDB(client);
  final APIService api = APIService();
  bool isMessagesSelected = true;
  final Encryption encrypt = Encryption();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchConnectedUsers(uid);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Stream<List<Map<String, dynamic>>> fetchConnectedUsers(String myUid) {
    return _supabaseDb.fetchConnectedUsers(myUid);
  }

  Stream<List<Map<String, dynamic>>> fetchUnknownUsers(String uid) {
    return _supabaseDb.fetchUnknownUsers(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mindfulBrown['Brown10'],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: mindfulBrown['Brown10'],
          title: Text(
            'Chat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: mindfulBrown['Brown80'],
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Main container for Messages and Connect

                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 55, // Set desired height here
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                // Content based on selection
                Expanded(
                    child: isMessagesSelected
                        ? StreamBuilder<List<Map<String, dynamic>>>(
                            stream: fetchConnectedUsers(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('No chats available'));
                              } else {
                                var filteredUsers = snapshot.data!
                                    .where((user) => user['name']
                                        .toLowerCase()
                                        .contains(_searchQuery))
                                    .toList();

                                return filteredUsers.isEmpty
                                    ? Center(child: Text('No results found'))
                                    : ListView.builder(
                                        itemCount: filteredUsers.length,
                                        itemBuilder: (context, index) {
                                          final user = filteredUsers[index];
                                          final name = user['name'];
                                          final avatarUrl = user['imageUrl'];
                                          final roomId = user['roomId'];
                                          final id = user['id'];
                                          final lastMessage =
                                              user['last_message'];
                                          final dateTime =
                                              DateTime.parse(user['time'])
                                                  .toUtc();
                                          final messageTime =
                                              DateFormat('h:mm a')
                                                  .format(dateTime);
                                          final read = user['read'];

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: ChatRow(
                                              avatarUrl: avatarUrl,
                                              name: name,
                                              lastMessage:
                                                  encrypt.decryptMessage(
                                                      lastMessage,
                                                      id.toString()),
                                              time: messageTime,
                                              read: read,
                                              onTap: () {
                                                context.push('/peer-chatscreen',
                                                    extra: {
                                                      'roomId': roomId,
                                                      'id': id,
                                                      'name': name
                                                    });
                                              },
                                            ),
                                          );
                                        },
                                      );
                              }
                            })
                        : StreamBuilder<List<Map<String, dynamic>>>(
                            stream: fetchUnknownUsers(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('No chats available'));
                              } else {
                                var filteredUsers = snapshot.data!
                                    .where((user) => user['name']
                                        .toLowerCase()
                                        .contains(_searchQuery))
                                    .toList();

                                return filteredUsers.isEmpty
                                    ? Center(child: Text('No results found'))
                                    : ListView.builder(
                                        itemCount: filteredUsers.length,
                                        itemBuilder: (context, index) {
                                          final user = filteredUsers[index];
                                          final userId = user['id'];
                                          final name =
                                              user['name'] ?? 'Unknown';
                                          final imageUrl = user['imageUrl'] ??
                                              'https://via.placeholder.com/150';

                                          return ConnectionRow(
                                            name: name,
                                            avatarUrl: imageUrl,
                                            onTap: () async {
                                              try {
                                                String roomId =
                                                    await api.createRoomId();
                                                final room = await _supabaseDb
                                                    .insertToPeerRoom(
                                                        roomId, uid, userId);
                                                context.push('/peer-chatscreen',
                                                    extra: {
                                                      'roomId': roomId,
                                                      'id': room
                                                    });
                                              } catch (e) {
                                                print(
                                                    'Error creating room: $e');
                                              }
                                            },
                                          );
                                        },
                                      );
                              }
                            },
                          ))
              ],
            ),

            //FLOATING
            Positioned(
              right: 16,
              bottom: 90,
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevent closing by tapping outside
                    builder: (context) => Dialog(
                      backgroundColor: Colors
                          .transparent, // Makes dialog background transparent
                      child: LoadingDialog(),
                    ),
                  );
                },
                elevation: 0,
                backgroundColor: mindfulBrown['Brown80'],
                shape: CircleBorder(),
                child: ClipOval(
                  child: Image.asset(
                    'assets/chatbot/icon/search.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20, // Distance from the bottom
              left: 16, // Distance from the left
              right: 16, // Distance from the right
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Main container background color
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container for "Messages"
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMessagesSelected = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: isMessagesSelected
                                ? serenityGreen['Green50']
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          child: Center(
                            child: Text(
                              'Messages',
                              style: TextStyle(
                                  color: isMessagesSelected
                                      ? Colors.white
                                      : mindfulBrown['Brown80'],
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Container for "Connect"
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMessagesSelected = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: !isMessagesSelected
                                ? empathyOrange['Orange40']
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          child: Center(
                            child: Text(
                              'Connect',
                              style: TextStyle(
                                  color: !isMessagesSelected
                                      ? Colors.white
                                      : mindfulBrown['Brown80'],
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
