// import 'package:riverpod/riverpod.dart';
// import 'package:stream_video_flutter/stream_video_flutter.dart';
// import 'package:lingap/features/virtual_consultation/models/user_model.dart';
// import 'package:lingap/features/virtual_consultation/utils/token_utils.dart';

// final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// class AuthService {
//   late final StreamVideo _client;

//   void initializeClient(UserModel userModel, bool isGuest) async {
//     final apiKey = 'REPLACE_WITH_API_KEY';
//     final userId = userModel.userId;
//     final userName = userModel.name;

//     if (isGuest) {
//       _client = StreamVideo(
//         apiKey,
//         user: User.guest(userId: userId),
//       );
//     } else {
//       final token = await TokenUtils.generateToken(userId);
//       _client = StreamVideo(
//         apiKey,
//         user: User.regular(
//           userId: userId,
//           name: userName,
//         ),
//         userToken: token,
//       );
//     }
//   }

//   StreamVideo get client => _client;
// }