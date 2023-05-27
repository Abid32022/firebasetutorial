import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/mysize.dart';

class GetProfileData extends StatefulWidget {
  const GetProfileData({Key? key}) : super(key: key);

  @override
  State<GetProfileData> createState() => _GetProfileDataState();
}

class _GetProfileDataState extends State<GetProfileData> {

  String name = "";
  String image = "";
  String email = "";
  String lastname = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfile();
    print('Yes');
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    print("image here");
    return Scaffold(
 //     backgroundColor: AppColors.bagroundColor,
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
        //  color: Colors.grey,
          child: Column(
            children: [

              SizedBox(height: MySize.size80,),
              Stack(
                clipBehavior: Clip.none,
                children: [

                  image == null? CircleAvatar(backgroundColor: Colors.red,):CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(image),
                  ),
                SizedBox(height: 40,),
                ],
              ),
              SizedBox(height: 40,),
              Text(name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              SizedBox(height: 20,),
              Text(lastname,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              SizedBox(height: 20,),
              Text(email,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),

            ],
          ),
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

      image = snapshot.get("image");

      email = snapshot.get("email");

      lastname = snapshot.get('last name');
      setState(() {});

    });
  }
}

