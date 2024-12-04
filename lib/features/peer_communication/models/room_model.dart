class RoomModel {
  final String roomId;
  final List<String> participants;
  final String status;

  RoomModel({
    required this.roomId,
    required this.participants,
    required this.status,
  });
}