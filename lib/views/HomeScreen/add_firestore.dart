import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:start/widgets/custom_button.dart';
import 'package:start/widgets/text_field.dart';

import '../../widgets/mysize.dart';
class AddFireStore extends StatefulWidget {
  const AddFireStore({Key? key}) : super(key: key);

  @override
  State<AddFireStore> createState() => _AddFireStoreState();
}

class _AddFireStoreState extends State<AddFireStore> {
  TextEditingController addController = TextEditingController();
  bool isloading = false;
  final firestore = FirebaseFirestore.instance.collection('InsertData');

  void uploadingData(){
    setLoadingTrue();
    setState(() {
      String id = DateTime.now().millisecond.toString();
     FirebaseFirestore.instance.collection('HomeScreenData')
         .doc(id).set({
       'Data' : addController.text.toString(),
       'uid'  : FirebaseAuth.instance.currentUser!.uid,
       'id': id,
     }).then((value) {
       print("Uploaded");
       setLoadingFalse();
     });
    });
  }

  void setLoadingTrue(){
    isloading = true;
    setState(() {
    });
  }
  void setLoadingFalse(){
    isloading = false;
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      body: Container(
        color: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(height: 100,),

            SizedBox(
              height: MySize.size54,
              child: textField(
                hintText: "Anything ....",
                fontSize: MySize.size16,
                fontWeight: FontWeight.w400,
                prefixIcon: false,
                prefixImage: "assets/icons/lock.png",
                suffix: true,
                bordercolor: Colors.transparent,
                filled: true,
                onChanged: (){},
                ontap: (){},
                fillcolor: Colors.white,
                controller: addController,
              ),
            ),
            SizedBox(height: 40,),
            GestureDetector(
              onTap: (){
                setState(() {
                  uploadingData();
                });
              },
              child: Container(
                height: 50,
                color: Colors.red,
                width: 300,
                child: Center(
                  child: isloading ? CircularProgressIndicator(): Text("Upload",style: TextStyle(fontWeight: FontWeight.w600,
                      fontSize: 16,color: Colors.white),),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
