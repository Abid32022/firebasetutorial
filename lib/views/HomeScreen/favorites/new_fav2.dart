import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'new_favrite_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Stream<QuerySnapshot> favoritesStream;

  @override
  void initState() {
    super.initState();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    favoritesStream = FirebaseFirestore.instance
        .collection('itemsData')
        .where('Favorites', arrayContains: userId)
        .snapshots();
  }

  void removeFavorite(String itemId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference itemRef =
    FirebaseFirestore.instance.collection('itemsData').doc(itemId);

    // Remove the user's ID from the item's favorites field
    await itemRef.update({
      'Favorites': FieldValue.arrayRemove([userId])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: favoritesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ItemTile> itemTiles = [];
            snapshot.data!.docs.forEach((doc) {
              itemTiles.add(ItemTile(
                image: doc['imageUrl'] ,
                onFavorite: removeFavorite,
                itemId: doc.id,
                title: doc['title'],
                subtitle: doc['subtitle'],
                isFavorite: true,
               // onFavorite: null,
                onUnfavorite: removeFavorite,
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
    );
  }
}
