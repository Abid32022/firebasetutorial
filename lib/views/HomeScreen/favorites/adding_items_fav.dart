import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/widgets/custom_button.dart';
import 'package:start/widgets/mysize.dart';
import 'package:start/widgets/text_field.dart';

class AddDataFav extends StatefulWidget {
  const AddDataFav({Key? key}) : super(key: key);

  @override
  State<AddDataFav> createState() => _AddDataFavState();
}

class _AddDataFavState extends State<AddDataFav> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();

  bool isloading = false;
  final firestore = FirebaseFirestore.instance.collection('InsertData');

  String imageurl = "";

  void uploadingData(){
    setLoadingTrue();
    setState(() {
     // String id = DateTime.now().millisecond.toString();
      FirebaseFirestore.instance.collection('itemsData')
          .doc().set({
        'title' : titleController.text.toString(),
        'subtitle': subtitleController.text.toString(),
         'Favorites': [],
          'imageUrl' : imageurl,

      }).then((value) {
        print("Uploaded");
        setLoadingFalse();
      });
    });
  }
  @override
  void dispose(){
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
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
    MySize().init(context);
    return Scaffold(
      body: Container(
        color: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(height: 100,),
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
            SizedBox(height: 40,),
            SizedBox(
              height: MySize.size54,
              child: textField(
                hintText: "title",
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
                controller: titleController,
              ),
            ),
            SizedBox(
              height: MySize.size54,
              child: textField(
                hintText: "subtitle",
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
                controller: subtitleController,
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
  _getProfile() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      print(snapshot.data());

      imageurl = snapshot.get("image");

      setState(() {});

    });
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
