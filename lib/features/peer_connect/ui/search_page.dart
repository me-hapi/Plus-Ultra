// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lingap/features/peer_connect/ui/loading_page.dart';

// class SearchPage extends ConsumerWidget {
//   const SearchPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Using a StateProvider to hold the isAnonymous state, as it's mutable.
//     final isAnonymous = ref.watch(isAnonymousProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Find a User'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Checkbox(
//                   value: isAnonymous,
//                   onChanged: (value) {
//                     ref.read(isAnonymousProvider.notifier).state =
//                         value ?? false;
//                   },
//                 ),
//                 const Text('Join as Anonymous'),
//               ],
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => LoadingPage()),
//                 );
//               },
//               child: const Text('Start Finding Users'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Define a StateProvider for isAnonymous
// final isAnonymousProvider = StateProvider<bool>((ref) => false);
