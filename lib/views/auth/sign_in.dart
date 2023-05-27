import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:start/views/HomeScreen/home_screen.dart';
import 'package:start/views/add_to_cart/add_to_cart.dart';
import 'package:start/views/auth/forgot_screen.dart';
import 'package:start/views/auth/phone_authentication.dart';
import 'package:start/views/auth/sign_up.dart';
import 'package:start/widgets/custom_button.dart';
import 'package:start/widgets/text_field.dart';

import '../../widgets/mysize.dart';
import '../follow&unfollow/uff.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool isloading = false;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwardcontroller = TextEditingController();
  final GoogleSignIn _googleSignIn =GoogleSignIn();

  void signIn(){
    setLoadingTrue();

    if (formkey.currentState!.validate()) {
      ///Success block
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailcontroller.text,
          password: passwardcontroller.text).then((value) {
        print("User is loged In");

        setLoadingFalse();

        Get.to(()=>uff());

      }).catchError((e){

        setLoadingFalse();

        print("SOmething went wrong");
      });
    }
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
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              SizedBox(height: 100,),
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
                  onChanged: (){},
                  ontap: (){},
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
                  suffix: true,
                  bordercolor: Colors.transparent,
                  filled: true,
                  onChanged: (){},
                  ontap: (){},
                  fillcolor: Colors.white,
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
              GestureDetector(
                onTap: (){
                  setState(() {
                    signIn();
                  });
                },
                child: Container(
                  height: 50,
                  color: Colors.red,
                  width: 300,
                  child: Center(
                    child: isloading ? CircularProgressIndicator(): Text("Next",style: TextStyle(fontWeight: FontWeight.w600,
                        fontSize: 16,color: Colors.white),),

                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: (){
                        Get.to(()=> SignUp());
                      },
                      child: Text("Sign Up",style: TextStyle(fontSize: 20,color: Colors.white),)),

                  GestureDetector(
                      onTap: (){
                        Get.to(()=> ForgotScreen());
                      },
                      child: Text("Forgot Screen",style: TextStyle(fontSize: 20,color: Colors.black87),)),


                  SizedBox(height: 70,),

                ],
              ),

              GestureDetector(
                  onTap: (){
                    setState(() {
                      _googleSignInk();
                    });
                     },
                  child: Icon(Icons.g_mobiledata,size: 40,)),
              SizedBox(height: 40,),
              GestureDetector(
                  onTap: (){
                    Get.to(()=> PhoneAuthentication());
                  },
                  child: Text("PhoneAuthentication",style: TextStyle(fontSize: 20,color: Colors.black87),)),


            ],
          ),
        ),
      ),
    );
  }

  Future<void> _googleSignInk() async {
   // setLoadingTrue();
    final googleSignIn = GoogleSignIn();
    final googleaccount = await googleSignIn.signIn();
    if (googleaccount != null) {
      final googleAuth = await googleaccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          await FirebaseAuth.instance.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          Get.to(const HomeScreen());
         // setLoadingFalse();
        } on FirebaseAuthException catch (e) {
          print(e);
          setLoadingFalse();
        } catch (error) {
          print(error);
      //    setLoadingFalse();
        } finally {}
      }
    }
  }
}
