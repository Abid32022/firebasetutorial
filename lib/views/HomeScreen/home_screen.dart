import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start/views/HomeScreen/add_firestore.dart';
import 'package:start/views/HomeScreen/favorites/adding_items_fav.dart';
import 'package:start/views/HomeScreen/allcrud/create.dart';
import 'package:start/views/HomeScreen/allcrud/fav_screen.dart';
import 'package:start/views/HomeScreen/favorites/new_fav2.dart';
import 'package:start/views/HomeScreen/get_profile_data.dart';
import 'package:start/views/HomeScreen/list_data_getting.dart';
import 'package:start/views/HomeScreen/favorites/new_favrite_screen.dart';
import 'package:start/views/HomeScreen/profile.dart';
import 'package:start/views/HomeScreen/searchbar.dart';
import 'package:start/views/add_to_cart/cartmodel.dart';
import 'package:start/views/add_to_cart/stats_cart.dart';
import 'package:start/views/auth/sign_in.dart';
import 'package:start/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> firestore;

  String name = "";

  CollectionReference ref = FirebaseFirestore.instance.collection('HomeScreenData');

  @override
  void initState() {
    super.initState();
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    firestore = FirebaseFirestore.instance
        .collection('HomeScreenData')
        .where('uid', isEqualTo: currentUserUid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HomeScreen",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                auth.signOut().then(
                  (value) {
                    Get.to(() => SignIn());
                  },
                );
              },
              child: Icon(Icons.logout)),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: firestore,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return CircleAvatar();
                    if (snapshot.hasError) return Text("Some error");
                    return Container(
                      height: 200,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        actions: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            height: 170,
                                            width: Get.width,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Are You Sure You want to Delete it",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                // ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                Center(
                                                  child: custombutton2(
                                                    text: "delete",
                                                    ontap: () {
                                                      ref
                                                          .doc(snapshot.data!
                                                              .docs[index]['id']
                                                              .toString())
                                                          .delete();
                                                      Get.back();
                                                    },
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    fontColor: Colors.white,
                                                    width: 120,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              title: Text(snapshot.data!.docs[index]['Data']
                                  .toString()),
                              //subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                            );
                          }),
                    );
                  }),
              SizedBox(
                height: 50,
              ),
              custombutton2(
                  text: "AddDataFav",
                  buttonColor: Colors.yellow,
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.red,
                  ontap: () {
                    Get.to(() => AddDataFav());
                  }),

              SizedBox(
                height: 50,
              ),
              custombutton2(
                  buttonColor: Colors.red,
                  text: "ItemScreen",
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  ontap: () {
                    Get.to(() => ItemScreen());
                  }),
              SizedBox(
                height: 50,
              ),
              //custombutton2(text: "Tab FavouriteScreen",fontColor: Colors.white,ontap: (){Get.to(()=>Item2());}),
              custombutton2(
                  buttonColor: Colors.red,
                  text: " FavouriteScreen",
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  ontap: () {
                    Get.to(() => FavoritesScreen());
                  }),
              SizedBox(
                height: 50,
              ),
              custombutton2(
                  text: "AddFireStore",
                  fontColor: Colors.white,
                  ontap: () {
                    Get.to(() => AddFireStore());
                  }),
              SizedBox(
                height: 20,
              ),
              custombutton2(
                  text: "GetProfile Data",
                  fontColor: Colors.white,
                  ontap: () {
                    Get.to(() => GetProfileData());
                  }),
              SizedBox(
                height: 20,
              ),
              custombutton2(
                  text: "Edit Profile",
                  fontColor: Colors.white,
                  ontap: () {
                    Get.to(() => EditProfile());
                  }),
              SizedBox(
                height: 20,
              ),
              custombutton2(
                  text: "Search Bar",
                  fontColor: Colors.white,
                  ontap: () {
                    Get.to(() => SearchDataPage());
                  }),
              SizedBox(
                height: 40,
              ),
              custombutton2(
                  text: "DocumentWithListDataPage",
                  fontColor: Colors.white,
                  ontap: () {
                    Get.to(() => DropdownDataPage());
                  }),
              SizedBox(
                height: 40,
              ),
              custombutton2(
                  text: "AllCrud",
                  fontColor: Colors.white,
                  ontap: () {
                    Get.to(() => CrudOperations());
                  }),
              SizedBox(
                height: 40,
              ),
              custombutton2(
                  text: "Shopping Cart",
                  fontColor: Colors.white,
                  ontap: () {
                    Get.to(() => ShoppingCart(model: CartModel()));
                  }),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
