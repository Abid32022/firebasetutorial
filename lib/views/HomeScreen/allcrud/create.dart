import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start/views/HomeScreen/allcrud/create_getting.dart';
import 'package:start/widgets/custom_button.dart';
import 'package:start/widgets/text_field.dart';
class CrudOperations extends StatefulWidget {
  const CrudOperations({Key? key}) : super(key: key);

  @override
  State<CrudOperations> createState() => _CrudOperationsState();
}

class _CrudOperationsState extends State<CrudOperations> {


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController hobbiesController = TextEditingController();

  final firestore = FirebaseFirestore.instance.collection('AddCollection');

  void addData(){
    isTruee();
    String id = DateTime.now().millisecond.toString();
    firestore.doc(id).set({
      'name' : nameController.text.toString(),
      'email': emailController.text.toString(),
      'phone no' : phoneController.text.toString(),
      'hobbies':hobbiesController.text.toString(),
       'id': id,
      'uid' :FirebaseAuth.instance.currentUser!.uid
    }).then((value) {
      print('uploaded');
      isFalse();
    }).onError((error, stackTrace) {
    });
  }

  bool isTrue = false;

  void isTruee(){
 setState(() {
   isTrue = true;
 });
  }
  void isFalse(){
    setState(() {
      isTrue = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,),
          child: Column(
            children: [
              SizedBox(height: 40,),

              Text("Create",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700,color: Colors.black),),
              SizedBox(height: 40,),
              textField(
                hintText: 'name',
                onChanged: (){},
                ontap: (){},
                fontSize: 14,
                fontWeight: FontWeight.w400,
                borderRadius: 10,
                bordercolor: Colors.red,
                enableborder: true,
                controller: nameController
              ),
              SizedBox(height: 40,),
              textField(
                hintText: 'email',
                onChanged: (){},
                ontap: (){},
                fontSize: 14,
                fontWeight: FontWeight.w400,
                borderRadius: 10,
                bordercolor: Colors.red,
                enableborder: true,
                controller: emailController
              ),
              SizedBox(height: 40,),
              textField(
                hintText: 'phone',
                onChanged: (){},
                ontap: (){},
                fontSize: 14,
                fontWeight: FontWeight.w400,
                borderRadius: 10,
                bordercolor: Colors.red,
                enableborder: true,
                controller: phoneController,
              ),
              SizedBox(height: 40,),
              textField(
                hintText: 'hobbies',
                onChanged: (){},
                ontap: (){},
                fontSize: 14,
                fontWeight: FontWeight.w400,
                borderRadius: 10,
                bordercolor: Colors.red,
                enableborder: true,
                controller: hobbiesController,
              ),
              SizedBox(height: 40,),
              GestureDetector(
                onTap: (){
                setState(() {
                  addData();
                });
                },
                child: Container(
                  height: 50,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)
                    ),
                  child:   Center(child: isTrue?CircularProgressIndicator():Text("Submit",style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w700),)),
                ),
              ),
              SizedBox(height: 40,),
              custombutton2(text: "AllCrud",fontColor: Colors.white,ontap: (){Get.to(()=>CreateGetting());}),

            ],
          ),
        ),
      ),
    );
  }
}
