// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// class FavoriteItemsScreen extends StatelessWidget {
//   final List<String> favoriteItemIds;
//
//   const FavoriteItemsScreen({Key? key, required this.favoriteItemIds})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .where(FieldPath.documentId, whereIn: favoriteItemIds)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//           final List<DocumentSnapshot> documents = snapshot.data!.docs;
//           return ListView(
//             children: documents.map((doc) {
//               final Map<String, dynamic>? data =
//               doc.data() as Map<String, dynamic>?;
//               final itemId = doc.id;
//              //final title = data?['name'] ?? '';
//               final title = data?['name'] ?? '';
//               final subtitle = data?['last name'] ?? '';
//               final image = data?['image'] ?? '';
//               return Container(
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: ListTile(
//                   leading: Container(
//                     height: 50,
//                     width: 50,
//                     child: Image.network(image),
//                   ),
//                   title: Text(title),
//                   subtitle: Text(subtitle),
//                   onTap: () {},
//                   trailing: Icon(Icons.favorite, color: Colors.red),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }