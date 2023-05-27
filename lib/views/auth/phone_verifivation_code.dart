import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start/views/HomeScreen/home_screen.dart';
import 'package:start/views/add_to_cart/cartmodel.dart';
import 'package:start/views/add_to_cart/stats_cart.dart';
import 'package:start/widgets/text_field.dart';

import '../add_to_cart/cleanscreen.dart';
class PhoneVerification extends StatefulWidget {
   PhoneVerification({Key? key,required this.Verificationcode}) : super(key: key);
  final  String Verificationcode;
  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController phoneControleller = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool isloading = false;

  void isTrueloading(){
    isloading = true;
    setState(() {

    });
  }
  void isFalseloading(){
    isloading = false;
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 40,),
            SizedBox(
              height: 54,
              child: textField(
                isKeyboard: true,
                hintText: "Verication",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                prefixIcon: false,
                prefixImage: "assets/icons/lock.png",
                suffix: true,
                bordercolor: Colors.transparent,
                filled: true,
                fillcolor: Colors.white,
                controller: phoneControleller,
                onChanged: (){},
                ontap: (){},

              ),
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isTrueloading();
                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.Verificationcode,
                    smsCode: phoneControleller.text.toString(),
                  );
                  try {
                    // await auth.signInWithCredential(credential);
                    Get.to(() => SaffScreen());
                  } catch (e) {
                    isFalseloading();
                  }
                });
                print('something went wrong');
              },
              child: Container(
                height: 50,
                color: Colors.red,
                width: 300,
                child: Center(
                  child: isloading != null && isloading
                      ? CircularProgressIndicator()
                      : Text(
                    "Next",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
