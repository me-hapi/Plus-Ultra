class MessageModel {
  final DateTime created_at;
  final String roomId;
  final String sender;
  final String content;

  MessageModel({
    required this.created_at,
    required this.roomId,
    required this.sender,
    required this.content,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      created_at: DateTime.parse(map['created_at'] as String),
      roomId: map['room_id'] as String,
      sender: map['sender'] as String,
      content: map['content'] as String,
    );
  }
}
