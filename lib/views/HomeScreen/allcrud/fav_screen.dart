import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Item2 extends StatefulWidget {
  @override
  _Item2State createState() => _Item2State();
}

class _Item2State extends State<Item2> {
  late Stream<QuerySnapshot> itemStream;

  @override
  void initState() {
    super.initState();
    itemStream = FirebaseFirestore.instance.collection('items').snapshots();
  }

  void favoriteItem(String itemId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference itemRef = FirebaseFirestore.instance.collection('items').doc(itemId);

    // Add the user's ID to the item's favorites field
    await itemRef.update({
      'favorites': FieldValue.arrayUnion([userId])
    });
  }

  void unfavoriteItem(String itemId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference itemRef = FirebaseFirestore.instance.collection('items').doc(itemId);

    // Remove the user's ID from the item's favorites field
    await itemRef.update({
      'favorites': FieldValue.arrayRemove([userId])
    });
  }

  // void uploadItemData() async {
  //   // Assuming you have the image URL, title, and subtitle
  //   String imageUrl = 'https://example.com/image.png';
  //   String title = 'Example Item';
  //   String subtitle = 'This is an example item';
  //
  //   // Create the item data
  //   Map<String, dynamic> itemData = {
  //     'imageUrl': imageUrl,
  //     'title': title,
  //     'subtitle': subtitle,
  //     'favorites': [],
  //   };
  //
  //   // Add the item to the "items" collection in Firestore
  //   await FirebaseFirestore.instance.collection('items').add(itemData);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: itemStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ItemTile> itemTiles = [];
            snapshot.data!.docs.forEach((doc) {
              itemTiles.add(ItemTile(itemId: doc.id, imageUrl: doc['imageUrl'],
                title: doc['title'],
                subtitle: doc['subtitle'],
                isFavorite: doc['favorites'].contains(FirebaseAuth.instance.currentUser!.uid),
                onFavorite: favoriteItem,
                onUnfavorite: unfavoriteItem,
              ));
            });

            return ListView(
              children: itemTiles,
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: uploadItemData,
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final String itemId;
  final String imageUrl;
  final String title;
  final String subtitle;
  final bool isFavorite;
  final Function(String) onFavorite;
  final Function(String) onUnfavorite;

  ItemTile({
    required this.itemId,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.isFavorite,
    required this.onFavorite,
    required this.onUnfavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.network(imageUrl),
    title: Text(title),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
        ),
        onPressed: () {
          if (isFavorite) {
            onUnfavorite(itemId);
          } else {
            onFavorite(itemId);
          }
        },
      ),
    );
  }
}

