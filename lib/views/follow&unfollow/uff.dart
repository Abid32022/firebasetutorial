import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'follow_unfollow.dart';

class uff extends StatelessWidget {

  init()async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =  AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Scaffold(

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          List<User> users = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return User(
              uid: doc.id,
              username: data['name'],
              following: [], // Provide empty list
              followers: [], // Provide empty list
            );
          }).toList();
          return UserListScreen(users: users);
       //   return UserListScreen(users: users);
        },
      ),
    );
  }
}
