import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:start/views/add_to_cart/add_to_cart.dart';
import 'package:start/views/add_to_cart/cart_page.dart';
import 'package:start/views/add_to_cart/cartmodel.dart';
import 'package:start/views/auth/sign_in.dart';
import 'package:start/widgets/custom_button.dart';
class ShoppingCart extends StatelessWidget{

  final CartModel model;

   ShoppingCart({Key ,required this.model});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel<CartModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping Cart',
        home: HomePage(),
        routes: {'/cart': (context) => CartPage()},
      ),
    );
  }
}
class Product {
  final String id;
  final String title;
  final double price;
  final String imgUrl;
  int qty;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imgUrl,
    this.qty = 1,
  });
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _getProfile();

  }
  Future<void> fetchProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await firestore.collection('products').get();
    List<Product> products = [];

    snapshot.docs.forEach((doc) {
      var data = doc.data();
      if (data != null) {
        double price = data['price'] is num ? (data['price'] as num).toDouble() : 0.0;
        Product product = Product(
          id: doc.id,
          title: data['title'] ?? '',
          price: price,
          imgUrl: data['imgUrl'] ?? '',
          qty: 1,
        );
        products.add(product);
      }
    });

    setState(() {
      _products = products;
    });
  }
  String imageurl = "";
  String name = "";

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(name,style: TextStyle(color: Colors.white),),
        actions: <Widget>[



          Stack(
            clipBehavior: Clip.none,
            children: [
              imageurl == null? CircleAvatar(backgroundColor: Colors.red,):CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageurl),
              ),
            ],
          ),
          GestureDetector(
              onTap: () {
                auth.signOut().then(
                      (value) {
                    Get.to(() => SignIn());
                  },
                );
              },
              child: Icon(Icons.logout)),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          )
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return ScopedModelDescendant<CartModel>(
            builder: (context, child, model) {
              return Card(
                child: Column(
                  children: <Widget>[
                    Image.network(
                      _products[index].imgUrl,
                      height: 120,
                      width: 120,
                    ),
                    Text(
                      _products[index].title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("\$" + _products[index].price.toString()),
                    custombutton2(
                      text: "Add",
                      ontap: () => model.addProduct(_products[index]),
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
  _getProfile() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      print(snapshot.data());

      name = snapshot.get("name");

      imageurl = snapshot.get("image");

      setState(() {});

    });
  }
}



// class HomePage extends StatelessWidget {
//
//   List<Product> _products = [
//     Product(id: 1, title: "Apple", price: 20.0, imgUrl: "https://img.icons8.com/plasticine/2x/apple.png", qty: 1),
//     Product(id: 2, title: "Banana", price: 40.0, imgUrl: "https://img.icons8.com/cotton/2x/banana.png", qty: 1),
//     Product(id: 3, title: "Orange", price: 20.0, imgUrl: "https://img.icons8.com/cotton/2x/orange.png", qty: 1),
//     Product(id: 4, title: "Melon", price: 40.0, imgUrl: "https://img.icons8.com/cotton/2x/watermelon.png", qty: 1),
//     Product(id: 5, title: "Avocado", price: 25.0, imgUrl: "https://img.icons8.com/cotton/2x/avocado.png", qty: 1),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.indigo[50],
//       appBar: AppBar(
//         backgroundColor: Colors.indigo,
//         title: Text("Home"),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.shopping_cart),
//             onPressed: () => Navigator.pushNamed(context, '/cart'),
//           )
//         ],
//       ),
//       body: GridView.builder(
//         padding: EdgeInsets.all(8.0),
//         itemCount: _products.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.8),
//         itemBuilder: (context, index){
//           return ScopedModelDescendant<CartModel>(
//               builder: (context, child, model) {
//                 return Card( child: Column( children: <Widget>[
//                   Image.network(_products[index].imgUrl, height: 120, width: 120,),
//                   Text(_products[index].title, style: TextStyle(fontWeight: FontWeight.bold),),
//                   Text("\$"+_products[index].price.toString()),
//                   custombutton2(text: "Add",ontap: () => model.addProduct(_products[index]),fontColor: Colors.white,fontWeight: FontWeight.w600),
//                 ]));
//               });
//         },
//       ),
//
//     );
//   }
// }
