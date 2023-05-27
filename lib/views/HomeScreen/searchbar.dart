import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchDataPage extends StatefulWidget {
  @override
  _SearchDataPageState createState() => _SearchDataPageState();
}

class _SearchDataPageState extends State<SearchDataPage> {
  late TextEditingController _searchController;
  late QuerySnapshot querySnapshot;
  late bool isSearching;

  Future getDocuments() async {
    querySnapshot = await FirebaseFirestore.instance
        .collection('InsertData')
        .get();
  }

  @override
  void initState() {
    super.initState();
    isSearching = false;
    _searchController = TextEditingController();
    getDocuments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (val) {
            setState(() {});
          },
        )
            : Text('My App'),
        actions: <Widget>[
          IconButton(
            icon: isSearching ? Icon(Icons.cancel) : Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  _searchController.clear();
                }
              });
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          isSearching
              ? SizedBox(height: 10)
              : SizedBox(height: 0),
          Expanded(
            child: FutureBuilder(
              future: getDocuments(),
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> data = querySnapshot.docs[index].data() as Map<String, dynamic>? ?? {};
                      String name = data['title'] ?? '';
                      String description = data['id'] ?? '';
                      if (isSearching &&
                          name
                              .toLowerCase()
                              .indexOf(_searchController.text.toLowerCase()) ==
                              -1) {
                        return SizedBox(height: 0);
                      } else {
                        return ListTile(
                          title: Text(name),
                          subtitle: Text(description),
                        );

                      }
                    },
                  );

                }
              },
            ),
          ),

        ],
      ),
    );
  }
}
