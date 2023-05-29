import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:start/views/auth/sign_in.dart';
import 'package:start/views/follow&unfollow/following.dart';
import 'package:http/http.dart' as http;


class User {
  final String uid;
  final String username;
  final List<String> following;
  final List<String> followers;

  User({
    required this.uid,
    required this.username,
    required this.following,
    required this.followers,
  });
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

class UserListScreen extends StatefulWidget {
  final List<User> users;

  UserListScreen({required this.users});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {

  List<String> userList = []; // Your userList

  String imageurl = "";
  String name = "";
  final auth = FirebaseAuth.instance;
  String? userNotificationToken;

  @override
  void initState() {
    super.initState();
    initializeLocalNotifications();
    _getProfile();
    _requestNotificationPermission();
    _saveNotificationToken();
  }

  ///Notification part starts here//

  void initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // Replace with your channel ID
      'your_channel_name', // Replace with your channel name

     //'your_channel_description', // Replace with your channel description
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.red,
      icon: '@mipmap/ic_launcher', // Replace with the name of the drawable resource for the small icon
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification title
      body, // Notification body
      platformChannelSpecifics,
      payload: 'your_custom_payload', // Optional: Custom payload to pass to the notification
    );
  }

  void _requestNotificationPermission() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
          message.notification!.title!,
          message.notification!.body!,
        );
      }
    });

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();
    print('Notification permission status: ${settings.authorizationStatus}');
  }

  ///Notification part end here//

  Future<List<String?>> getAllUserNotificationTokens() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').get();
      List<String?> notificationTokens = [];

      for (QueryDocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic>? data =
        document.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('notificationToken')) {
          notificationTokens.add(data['notificationToken'] as String?);
          // Trigger the notification here
          showNotification('New User', 'A new user has been added');

        } else {
          print('User document does not contain a valid token field');
          notificationTokens.add(null);
        }
      }

      return notificationTokens;
    } catch (e) {
      print('Error getting user notification tokens: $e');
      return [];
    }
  }


  void _saveNotificationToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (token != null) {
      setState(() {
        userNotificationToken = token;
      });
      print('Notification Token: $token');
      // Save the token to Firebase for the current user
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'notificationToken': token});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showNotification('Buddy', 'body');
        },
      ),
      appBar: AppBar(
        title: Text(name),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              imageurl == null? CircleAvatar(backgroundColor: Colors.red,):CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageurl),
              ),
            ],
          ),
          SizedBox(width: 20),

          GestureDetector(
            onTap: () {
              auth.signOut().then(
                (value) {
                  Get.to(() => SignIn());
                },
              );
            },
            child: Icon(Icons.logout),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<String?>>(
              future: getAllUserNotificationTokens(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String?> notificationTokens = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: widget.users.length,
                    itemBuilder: (context, index) {
                      User user = widget.users[index];
                      if (user.uid != FirebaseAuth.instance.currentUser!.uid) {
                        String? userNotificationToken = notificationTokens[index];
                        return ListTile(
                          title: Text(user.username),
                          trailing: FollowButton(
                            user: user,
                            userNotificationToken: userNotificationToken,
                          ),
                        );
                      } else {
                        return Container(); // Hide the current user from the list
                      }
                    },
                  );
                }
              },
            ),
          ),


          ElevatedButton(
            onPressed: () => navigateToFollowersScreen(context),
            child: Text('Followers'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => navigateToFollowingScreen(context),
            child: Text('Following'),
          ),
          SizedBox(height: 50),
        ],
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

      name = snapshot.get("name");

      imageurl = snapshot.get("image");

      setState(() {});
    });
  }

  void navigateToFollowersScreen(BuildContext context) async {
    List<String> followers =
        await getFollowers(FirebaseAuth.instance.currentUser!.uid);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowersScreen(followers: followers),
      ),
    );
  }

  void navigateToFollowingScreen(BuildContext context) async {
    List<String> following =
        await getFollowing(FirebaseAuth.instance.currentUser!.uid);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowingScreen(following: following),
      ),
    );
  }

  Future<List<String>> getFollowing(String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('following')
        .get();

    List<String> following = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      String followingId = doc.id;
      DocumentSnapshot followingSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(followingId)
          .get();

      if (followingSnapshot.exists) {
        String followingName =
            (followingSnapshot.data() as Map<String, dynamic>)['name'];
        if (followingName != null) {
          following.add(followingName);
        }
      }
    }

    return following;
  }
  Future<List<String>> getFollowers(String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('followers')
        .get();

    List<String> followers = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      String followerId = doc.id;
      DocumentSnapshot followerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(followerId)
          .get();

      if (followerSnapshot.exists) {
        String followerName =
        (followerSnapshot.data() as Map<String, dynamic>)['name'];
        if (followerName != null) {
          followers.add(followerName);
        }
      }
    }

    return followers;
  }

}

class FollowButton extends StatefulWidget {
  final User user;
  final String? userNotificationToken;

  FollowButton({
    required this.user,
    required this.userNotificationToken,
  });

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false;
  //getting follower  name
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<String> getFollowerName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null && userData.containsKey('name')) {
          return userData['name'];
        }
      }
    } catch (e) {
      print('Error getting follower name: $e');
    }

    return ''; // Return an empty string if the name is not found or there was an error
  }
  Future<void> sendNotificationToUser(String token) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return; // Return early if the current user is null
    }

    final followerName = await getFollowerName(currentUser.uid);
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAPnvZz3E:APA91bEM4R7DFOriz77QTk7YdZW82cazrjTGwJn4ShqmacrA4Id18cIGn6N4MFAO50JULv8sCus8NchzgGZAvRcEIyX8CwBEkuaBj1GqUZdtVt7upIazoIpmeb0XSnuKwvwedv9d0jZq',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': 'New Follower',
            'body':
                ' $followerName had Followed you',
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'user_id': FirebaseAuth.instance.currentUser!.uid,
          },
          'to': token,
        },
      ),
    );
  }

  void followUser() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    String followedUserId = widget.user.uid;

    // Update following collection for the current user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('following')
        .doc(followedUserId)
        .set({});

    // Update followers collection for the user being followed
    await FirebaseFirestore.instance
        .collection('users')
        .doc(followedUserId)
        .collection('followers')
        .doc(currentUserId)
        .set({});

    setState(() {
      isFollowing = true;
    });

    // Get the followed user's information
    DocumentSnapshot followedUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();
    if (followedUserSnapshot.exists) {
      String followedUserName = followedUserSnapshot.get('name');
    }

    // Send a notification to the followed user if the token is available
    if (widget.userNotificationToken != null) {
      print("User Notification is here ${widget.userNotificationToken}");
      await sendNotificationToUser(widget.userNotificationToken!);
    }
  }

  void unfollowUser() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    String followedUserId = widget.user.uid;

    // Remove from following collection for the current user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('following')
        .doc(followedUserId)
        .delete();

    // Remove from followers collection for the user being unfollowed
    await FirebaseFirestore.instance
        .collection('users')
        .doc(followedUserId)
        .collection('followers')
        .doc(currentUserId)
        .delete();

    setState(() {
      isFollowing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkFollowingStatus();
  }

  void checkFollowingStatus() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('following')
        .doc(widget.user.uid)
        .get();

    setState(() {
      isFollowing = snapshot.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isFollowing
        ? ElevatedButton(
            onPressed: unfollowUser,
            child: Text('Unfollow'),
          )
        : ElevatedButton(
            onPressed: followUser,
            child: Text('Follow'),
          );
  }
}