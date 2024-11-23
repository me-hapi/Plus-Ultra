// import 'package:stream_video_flutter/stream_video_flutter.dart';
// import 'package:lingap/features/virtual_consultation/services/auth_services.dart';
// import 'package:riverpod/riverpod.dart';

// final streamVideoServiceProvider = Provider<StreamVideoService>((ref) {
//   final authService = ref.watch(authServiceProvider);
//   return StreamVideoService(authService);
// });

// class StreamVideoService {
//   final AuthService _authService;

//   StreamVideoService(this._authService);

//   Future<void> makeAndJoinCall() async {
//     final client = _authService.client;
//     final call = client.makeCall(
//       callType: StreamCallType.defaultType(),
//       id: 'Your-call-ID',
//     );
//     await call.getOrCreate();
//     await call.join();
//   }
// }
