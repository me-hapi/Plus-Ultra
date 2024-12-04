// import 'dart:typed_data';
// import 'package:dvdb/dvdb.dart';

// class VectorDB {
//   final DVDB _dvdb;
//   final Collection _collection;

//   VectorDB(String collectionName)
//       : _dvdb = DVDB(),
//         _collection = DVDB().collection(collectionName);

//   void add({required String text, Float64List? embedding}) {
//     try {
//       _collection.addDocument(null, text, embedding!);
//       print('Document added successfully: $text');
//     } catch (e) {
//       print('An error occurred while adding the document: $e');
//     }
//   }

//   String search(Float64List embedding, int numResults) {
//     try {
//       final query = _collection.search(embedding, numResults: numResults);
//       String result = '';
//       query.forEach((element) {
//         print("${element.score} || ${element.text}");
//         result = element.text;
//       });

//       return result;
//     } catch (e) {
//       print('An error occurred while searching: $e');
//       return '';
//     }
//   }
// }