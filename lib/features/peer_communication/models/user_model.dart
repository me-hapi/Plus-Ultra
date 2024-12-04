class UserModel {
  final String id;
  final String username;
  final String status;
  final bool isAnonymous;

  UserModel({
    required this.id,
    required this.username,
    required this.status,
    required this.isAnonymous,
  });
}