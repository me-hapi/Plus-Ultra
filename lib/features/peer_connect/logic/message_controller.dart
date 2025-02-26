import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/utils/security/encryption.dart';
import 'package:lingap/features/peer_connect/data/supabase_db.dart';
import 'package:lingap/features/peer_connect/models/message_model.dart';

final messageControllerProvider = Provider((ref) => MessageController());

class MessageController {
  final SupabaseDB _supabaseDb = SupabaseDB(client);
  final Encryption encrypt = Encryption();

  Stream<List<MessageModel>> getMessages(int id) {
    return _supabaseDb.getPeerMessagesStream(id);
  }

  // Method to send a message
  Future<void> sendMessage(String content, int id) async {
    try {
      final message = MessageModel(
          id: 0,
          created_at: DateTime.now(),
          roomId: id,
          sender: uid,
          content: encrypt.encryptMessage(content, id.toString()),
          unsent: false);

      await _supabaseDb.insertPeerMessage(message);
    } catch (e) {}
  }

  Future<void> unsendMessage(int id) async {
    try {
      await _supabaseDb.unsendMessage(id);
    } catch (e) {}
  }
}
