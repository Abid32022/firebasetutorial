import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/mysize.dart';
import '../../widgets/text_field.dart';


class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool visible = true;
  bool isloading = false;

  String name = "";
  String imageurl = " ";
  String email = "";
  String lastname = "";

  final nameController = TextEditingController();
  final userAgeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    userAgeController.dispose();
    super.dispose();
  }

  void _addData() {
    setLoadingTrue();
   // String id = DateTime.now().millisecond.toString();
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'name': nameController.text,
      'last name': userAgeController.text,
      "image": imageurl,
      "uid"  : FirebaseAuth.instance.currentUser!.uid,
    },
        SetOptions(merge: true)).then((value) {
      print('done');
      setLoadingFalse();
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProfile();
    print('Yes');
  }

  @override
  Widget build(BuildContext context) {

    MySize().init(context);
    return Scaffold(
      body: Container(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MySize.size40,
            ),
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
                      child: imageurl == " "
                          ? Icon(
                        Icons.person,
                        size: 30,
                      )
                          : ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            imageurl,
                            fit: BoxFit.fill,
                          )),
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
            SizedBox(
              height: MySize.size5,
            ),

            SizedBox(height: MySize.size30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    height: MySize.size5,
                  ),
                  Container(
                      height: MySize.size54,
                      child: textField(
                          hintText: name,
                          fontSize: MySize.size16,
                          fontWeight: FontWeight.w400,
                          prefixIcon: false,
                          onChanged: (){},
                          ontap: (){},
                          bordercolor: Colors.transparent,
                          filled: true,
                          fillcolor: Colors.white,
                          controller: nameController
                      )),
                  SizedBox(
                    height: MySize.size15,
                  ),

                  SizedBox(
                    height: MySize.size5,
                  ),
                  SizedBox(
                    height: MySize.size54,
                    child: textField(
                      hintText: lastname,
                      fontSize: MySize.size16,
                      fontWeight: FontWeight.w400,
                      prefixIcon: false,
                      prefixImage: "assets/icons/lock.png",
                     // isObscure: visible,
                      bordercolor: Colors.transparent,
                      filled: true,
                      ontap: (){},
                      onChanged: (){},
                      fillcolor: Colors.white,
                      controller: userAgeController,
                    ),
                  ),


                  SizedBox(
                    height: MySize.size40,
                  ),
                  GestureDetector(
                    onTap: (){
                   setState(() {

                     _addData();
                     });
                    },

                    child: Container(
                      height: 50,
                      color: Colors.red,
                      width: 300,
                      child: Center(
                        child: isloading ? CircularProgressIndicator(): Text("Update",style: TextStyle(fontWeight: FontWeight.w600,
                            fontSize: 16,color: Colors.white),),



                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      print(snapshot.data());

       name = snapshot.get("name");

      imageurl = snapshot.get("image");

        email = snapshot.get("email");

        lastname = snapshot.get("last name");

      setState(() {});

    });
  }
  ImagePicker picker = ImagePicker();

  File? file;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 30);
    if (pickedFile != null && pickedFile.path != null) {
      file = File(pickedFile.path);
      setState(() {});
      // ignore: use_build_context_synchronously
      imageurl = await UploadFileServices().getUrl(context, file: file!);
    }
  }


}


class UploadFileServices {
  ///Upload Image to Storage
  Future<String> getUrl(BuildContext context, {required File file}) async {
    late String postFileUrl;
    try {
      print(file);
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${file.path.split('/').last}');
      UploadTask uploadTask = storageReference.putFile(file);
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        final progress =
            100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
        print("_______________________${progress}");
      });
      await uploadTask.whenComplete(() async {
        await storageReference.getDownloadURL().then((fileURL) {
          postFileUrl = fileURL;
        });
      });
      return postFileUrl;
    }
    on FirebaseException catch (e) {
      //   getFlushBar(context, title: "${e.message}");
      rethrow;
    }
  }
}
