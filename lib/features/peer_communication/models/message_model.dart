class MessageModel {
  final String messageId;
  final String senderId;
  final String content;
  final DateTime timestamp;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });
}
