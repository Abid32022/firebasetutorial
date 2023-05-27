
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:start/views/HomeScreen/home_screen.dart';
import 'package:start/views/add_to_cart/add_to_cart.dart';
import 'package:start/views/add_to_cart/cartmodel.dart';
import 'package:start/views/add_to_cart/stats_cart.dart';
import 'package:start/views/auth/splash_screen.dart';
import 'package:start/views/follow&unfollow/follow_unfollow.dart';
import 'package:start/views/follow&unfollow/uff.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  playSound: true);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  print('A big message just showed up :${message.messageId}');
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage((_firebaseMessagingBackgroundHandler));

 await flutterLocalNotificationsPlugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
 ?.createNotificationChannel(channel);

 await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
   alert: true,
   badge: true,
   sound: true,
 );

  runApp(myApp());
}
class myApp extends StatelessWidget {
    @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
     home: FirebaseAuth.instance.currentUser == null ? SplashScreen(): uff());

  }
}
