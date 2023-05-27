import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemScreen extends StatefulWidget {
  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late Stream<QuerySnapshot> itemStream;

  @override
  void initState() {
    super.initState();
    itemStream = FirebaseFirestore.instance.collection('itemsData').snapshots();
  }

  void favoriteItem(String itemId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference itemRef =
    FirebaseFirestore.instance.collection('itemsData').doc(itemId);

    // Add the user's ID to the item's favorites field
    await itemRef.update({
      'Favorites': FieldValue.arrayUnion([userId])
    });
  }

  void unfavoriteItem(String itemId) async {
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
        title: Text('Item Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: itemStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ItemTile> itemTiles = [];
            snapshot.data!.docs.forEach((doc) {
              itemTiles.add(ItemTile(

                title: doc['title'],
                subtitle: doc['subtitle'],
                image: doc['imageUrl'],
                itemId: doc.id,
                isFavorite: doc['Favorites']
                    .contains(FirebaseAuth.instance.currentUser!.uid),
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
    );
  }
}

class ItemTile extends StatelessWidget {
  final String itemId;
  final String title;
  final String subtitle;
  final String image;
  final bool isFavorite;
  final Function(String) onFavorite;
  final Function(String) onUnfavorite;

  ItemTile({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.itemId,
    required this.isFavorite,
    required this.onFavorite,
    required this.onUnfavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(image,fit: BoxFit.fill,))),
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
