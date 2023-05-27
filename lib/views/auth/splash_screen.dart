import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start/views/auth/sign_in.dart';
import 'package:start/widgets/custom_button.dart';
import 'package:start/widgets/mysize.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SizedBox(height: 40),
          Text("Splash Screen",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,
          ),),

            SizedBox(height: 100,),
            custombutton2(text: "Next",fontColor: Colors.white,fontWeight: FontWeight.w700,ontap: (){
          Get.to(()=>SignIn());
            }),
        ],),
      ),
    );
  }
}
