import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start/views/auth/phone_verifivation_code.dart';
import 'package:start/widgets/text_field.dart';
class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({Key? key}) : super(key: key);

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
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
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 40,),
            SizedBox(height: 40,),
            SizedBox(
              height: 54,
              child: textField(
                isKeyboard: false,
                hintText: "Email",
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
            SizedBox(height: 40,),
            GestureDetector(
              onTap: (){
                setState(() {
                    isTrueloading();
                  auth.verifyPhoneNumber(
                    phoneNumber: phoneControleller.text,
                      verificationCompleted: (_){
                        isFalseloading();
                      },
                      verificationFailed: (e){
                        isFalseloading();
                      print('something went wrong');
                      },
                      codeSent: (String verification , int? token){
                      Get.to(()=>PhoneVerification(Verificationcode: verification,)  );
                      isFalseloading();
                      },
                      codeAutoRetrievalTimeout: (e){

                      print ("something wrong happen");
                      isFalseloading();
                      });
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
          ],
        ),
      ),
    );
  }
}
