import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreExpansionTile extends StatefulWidget {
  @override
  _FirestoreExpansionTileState createState() => _FirestoreExpansionTileState();
}

class _FirestoreExpansionTileState extends State<FirestoreExpansionTile> {
  late List<Map<String, dynamic>> _documents;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('try').get();
      final documents = snapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        _documents = documents;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Expansion Tile'),
      ),
      body: Center(
        child: _documents != null
            ? ListView.builder(
          itemCount: _documents.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionTile(
              title: Text("${_documents[index]['type']}"),
              children: [
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text("Fruit:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, fruitIndex) {
                          return Text("${_documents[index]['fruit'][fruitIndex]}");
                        },
                        itemCount: _documents[index]['fruit']?.length ?? 0,
                      ),
                      SizedBox(height: 10),
                      //Text("Vegetables:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, vegIndex) {
                          return Text("${_documents[index]['veg'][vegIndex]}");
                        },
                        itemCount: _documents[index]['veg']?.length ?? 0,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}


//
// class ColumnWIse extends StatefulWidget {
//   const ColumnWIse({Key? key}) : super(key: key);
//
//   @override
//   State<ColumnWIse> createState() => _ColumnWIseState();
// }
//
// class _ColumnWIseState extends State<ColumnWIse> {
//   List<type> yeslist = [
//  type("Vegitable", "ladyfinger", "brocolli", "palak",),
//  type("Fruits", "banana", "nashpati", "orange"),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: 60,),
//           Expanded(
//             child: ListView.builder(
//               itemCount: yeslist.length,
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context,index){
//               return ExpansionTile(
//                 // trailing: Image.asset("assets/icons/dropicon.png",height: 15,width: 15,),
//                 title: Text(yeslist[index].title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
//                 childrenPadding:EdgeInsets.only(left: 15),
//                 expandedAlignment: Alignment.topLeft,
//                 children: [
//                   Text(yeslist[index].Veg1),
//                   Text(yeslist[index].Veg2),
//                   Text(yeslist[index].Veg3),
//                 //  Text("Does it cost to attend a Link?"),
//
//                 ],
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class type{
//   String title;
//   String Veg1;
//   String Veg2;
//   String Veg3;
//
//   type(this.title,this.Veg1,this.Veg2,this.Veg3);
// }
