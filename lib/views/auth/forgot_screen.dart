import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start/views/HomeScreen/home_screen.dart';
import 'package:start/views/auth/sign_in.dart';
import 'package:start/widgets/custom_button.dart';
import '../../widgets/mysize.dart';
import '../../widgets/text_field.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  bool isloading = false;

  TextEditingController forgotpassController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void forgotPassward(){
    setLoadingTrue();
    try{
      FirebaseAuth.instance.sendPasswordResetEmail(email:  forgotpassController.text).
      then((value) => {
        print("Email Sent"),

        Get.off(()=> SignIn()),
      setLoadingFalse()

      });
    }on FirebaseAuthException catch(e){
      setLoadingFalse();
      print("Error $e");
    }
  }
  bool isLoading = false;
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
    print('Here is $forgotpassController');
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        color: Colors.grey,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 80,),
              Text('Forgot Screen',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600,color: Colors.black87),),
              SizedBox(height: 40,),
              SizedBox(
                height: MySize.size54,
                child: textField(
                  hintText: "Password",
                  fontSize: MySize.size16,
                  fontWeight: FontWeight.w400,
                  prefixIcon: false,
                  prefixImage: "assets/icons/lock.png",
                  //  isObscure: visible,
                  ontap: (){},
                  onChanged: (){},
                  suffix: true,
                  bordercolor: Colors.transparent,
                  filled: true,
                  fillcolor: Colors.white,
                  controller: forgotpassController,
                ),
              ),
              SizedBox(height: 50,),

              custombutton2(
                  text: "Reset",ontap: ()async{
                forgotPassward();

              }),


            ],
          ),
        ),
      ),
    );
  }
}
