import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/utils/security/encryption.dart';
import 'package:lingap/features/peer_connect/data/supabase_db.dart';
import 'package:lingap/features/peer_connect/models/message_model.dart';

final messageControllerProvider = Provider((ref) => MessageController());

class MessageController {
  final SupabaseDB _supabaseDb = SupabaseDB(client);
  final Encryption encrypt = Encryption();

  Stream<List<MessageModel>> getMessages(String roomId) {
    return _supabaseDb.getMessagesStream(roomId);
  }

  // Method to send a message
  Future<void> sendMessage(String content, String roomId) async {
    try {
      final message = MessageModel(
          created_at: DateTime.now(),
          roomId: roomId,
          sender: uid,
          content: encrypt.encryptMessage(content, uid.substring(0,32)));
      await _supabaseDb.insertMessage(message);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
