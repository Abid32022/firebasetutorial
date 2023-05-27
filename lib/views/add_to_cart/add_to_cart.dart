import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/views/add_to_cart/cartmodel.dart';
import 'package:start/views/add_to_cart/stats_cart.dart';
import 'package:start/widgets/custom_button.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({Key? key}) : super(key: key);

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  String imageurl = "";
  String name = "";
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfile();
    print('Yes');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              imageurl == null? CircleAvatar(backgroundColor: Colors.red,):CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageurl),
              ),
            ],
          ),
        ],
      ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22,),
                Text("Product Screen",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.black),),
                SizedBox(height: 50,),

              // custombutton2(
              //     ontap: (){
              //       Get.to(()=>ShoppingCart(model: CartModel(),));
              //     },
              //     text: "Submit",fontSize: 15,fontWeight: FontWeight.w600,fontColor: Colors.white),
                custombutton2(
                    ontap: (){
                      Get.to(()=>ShoppingCart(model: CartModel(),));
                    },
                    text: "Submit",fontSize: 15,fontWeight: FontWeight.w600,fontColor: Colors.white),

              ],
            ),
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

// class Product {
//   int id;
//   String title;
//   String imgUrl;
//   double price;
//   int qty;
//
//   Product({required this.id,required this.title,required this.price,required this.qty,required this.imgUrl});
// }
