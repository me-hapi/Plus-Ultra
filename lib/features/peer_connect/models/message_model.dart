class MessageModel {
  final int id;
  final DateTime created_at;
  final int roomId;
  final String sender;
  final String content;
  final bool unsent;

  MessageModel(
      {required this.id,
      required this.created_at,
      required this.roomId,
      required this.sender,
      required this.content,
      required this.unsent});

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
        id: map['id'] as int,
        created_at: DateTime.parse(map['created_at'] as String),
        roomId: map['room_id'] as int,
        sender: map['sender'] as String,
        content: map['content'] as String,
        unsent: map['unsent'] as bool);
  }
}
