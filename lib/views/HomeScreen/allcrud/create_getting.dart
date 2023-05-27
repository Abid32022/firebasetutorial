import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:start/views/HomeScreen/allcrud/create.dart';
import 'package:start/widgets/custom_button.dart';
class CreateGetting extends StatefulWidget {
  const CreateGetting({Key? key}) : super(key: key);

  @override
  State<CreateGetting> createState() => _CreateGettingState();
}

class _CreateGettingState extends State<CreateGetting> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> firestore;

  //final firestore = FirebaseFirestore.instance.collection('AddCollection').snapshots();
  final ref = FirebaseFirestore.instance.collection('AddCollection');

  @override
  void initState(){
    super.initState();
    setState(() {
      firestore = FirebaseFirestore.instance.collection('AddCollection')
          .where('uid' ,isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
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
       body: Container(
         width: Get.width,
         child: Column(
           children: [
             SizedBox(height: 40,),

             Text("Getting Data",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 24),),
             SizedBox(height: 40,),
             Text("Getting Data in List in ListView.builder",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 15),),
             SizedBox(height: 40,),

             StreamBuilder<QuerySnapshot>(
               stream: firestore,
                 builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return CircularProgressIndicator();
                  if(snapshot.hasError)
                    return Text('has Error');
                 return Expanded(
                   child: ListView.builder(
                       padding: EdgeInsets.zero,
                       shrinkWrap: true,
                       physics: AlwaysScrollableScrollPhysics(),
                       itemCount: snapshot.data!.docs.length,
                       itemBuilder: (context,index){
                         return ListTile(
                           onTap: (){

                             ref.doc(snapshot.data!.docs[index]['id']).delete();
                           },
                           leading: Text(snapshot.data!.docs[index]['name']),
                           title: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(snapshot.data!.docs[index]['hobbies']),
                               Text(snapshot.data!.docs[index]['email']),
                             ],
                           ),
                           trailing:  Text(snapshot.data!.docs[index]['phone no']),

                         );
                       }),
                 );
                 }),
             SizedBox(height: 40,),
             Text("Creating  single Data",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 15),),
             SizedBox(height: 40,),
             custombutton2(text: "Creating single data",fontColor: Colors.white,ontap: (){Get.to(()=>CrudOperations());}),
             SizedBox(height: 40,),


           ],
         ),
       ),
    );
  }
}
