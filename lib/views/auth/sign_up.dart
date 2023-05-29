import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/views/add_to_cart/add_to_cart.dart';
import 'package:start/views/auth/sign_in.dart';
import 'package:start/widgets/custom_button.dart';
import 'package:start/widgets/text_field.dart';
import '../../widgets/mysize.dart';
import '../HomeScreen/favorites/adding_items_fav.dart';
import '../HomeScreen/home_screen.dart';
import '../follow&unfollow/uff.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController username= TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwardcontroller = TextEditingController();
  bool isloading = false;

  String imageUrl = "";

  validateMyInputs(){
    setLoadingTrue();
    if(formkey.currentState!.validate()){
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailcontroller.text.trim(), password: passwardcontroller.text.trim())
          .then((value){
        print(value.user!.uid);
        /// store data into firebase
        FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set(
            {
              'name': username.text.trim(),
              'email': emailcontroller.text.trim(),
              'uid' : FirebaseAuth.instance.currentUser!.uid,
              'image': imageUrl
            });
        setLoadingFalse();
        Get.to(() => uff());
      });
    }
  }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfile();
    print('Yes');
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
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                SizedBox(height: 100,),

                Text('SignUp',style: TextStyle(fontSize: 30,color: Colors.white),),
                SizedBox(height: 50,),

                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red)),
                        padding: EdgeInsets.all(1),
                        child: Container(
                          height: MySize.size90,
                          width: MySize.size90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: imageUrl == " "
                              ? Icon(
                            Icons.person,
                            size: 30,
                          )
                              : null
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Container(
                            height: MySize.size22,
                            width: MySize.size22,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.camera_alt_outlined,color: Colors.white,size: 15,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50,),

                SizedBox(
                  height: MySize.size54,
                  child: textField(
                    hintText: "Name",
                    fontSize: MySize.size16,
                    fontWeight: FontWeight.w400,
                    prefixIcon: false,
                    prefixImage: "assets/icons/lock.png",
                    suffix: true,
                    bordercolor: Colors.transparent,
                    filled: true,
                    fillcolor: Colors.white,
                    controller: username,
                    onChanged:(){},
                    ontap: (){},
                    validator: (String? input){
                      if(input!.isEmpty){
                        return 'Please enter password';
                      }
                      if(input.length< 6){
                        return "Password should be 6+ characters";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: MySize.size54,
                  child: textField(
                    hintText: "Email",
                    fontSize: MySize.size16,
                    fontWeight: FontWeight.w400,
                    prefixIcon: false,
                    prefixImage: "assets/icons/lock.png",
                    suffix: true,
                    bordercolor: Colors.transparent,
                    filled: true,
                    fillcolor: Colors.white,
                    controller: emailcontroller,
                    ontap: (){},
                    onChanged: (){},
                    validator: (String? input){
                      if(input!.isEmpty){
                        return 'Please enter your email';
                      }
                      if(!input.isEmail){
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20,),

                SizedBox(
                  height: MySize.size54,
                  child: textField(
                    hintText: "Password",
                    fontSize: MySize.size16,
                    fontWeight: FontWeight.w400,
                    prefixIcon: false,
                    prefixImage: "assets/icons/lock.png",
                    //  isObscure: visible,
                    suffix: true,
                    bordercolor: Colors.transparent,
                    filled: true,
                    fillcolor: Colors.white,
                    ontap: (){},
                    onChanged: (){},
                    controller: passwardcontroller,
                      validator: (String? input) {
                if (input!.isEmpty) {
                return 'Enter your password';
                }
                if (input.length < 6) {
                return 'Password should be 6+ characters long';
                }
                return null;
                },
                  ),
                ),

                SizedBox(height: 50,),

                custombutton2(text: "Next",fontColor: Colors.white,fontWeight: FontWeight.w700,
                    ontap: (){
                  validateMyInputs();
                }),

                SizedBox(height: 20,),

                GestureDetector(
                    onTap: (){
                      Get.to(()=>SignIn());
                    },
                    child: Text("Sign In",style: TextStyle(fontSize: 20,color: Colors.white),)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: Text('Gallery'.tr),
                      onTap: () {
                        getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: Text('Camera'.tr),
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _getProfile() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
        print(snapshot.data());

        imageUrl = snapshot.get("image") ?? ""; // Use null-aware operator or provide a default value

        setState(() {});
      });
    }
  }
  ImagePicker picker = ImagePicker();

  File? file;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 30);
    if (pickedFile != null && pickedFile.path != null) {
      file = File(pickedFile.path);
      setState(() {});
      // ignore: use_build_context_synchronously
      imageUrl = await UploadFileServices().getUrl(context, file: file!);
    }
  }

}
