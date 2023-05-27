import 'package:flutter/material.dart';

class FollowersScreen extends StatelessWidget {
  final List<String> followers;

  FollowersScreen({required this.followers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),

      body: ListView.builder(
        // shrinkWrap: true,
        // physics: AlwaysScrollableScrollPhysics(),
        itemCount: followers.length,
        itemBuilder: (context, index) {
          String follower = followers[index];
          return ListTile(
            title: Text(follower),
          );
        },
      ),
    );
  }
}

class FollowingScreen extends StatelessWidget {
  final List<String> following;

  FollowingScreen({required this.following});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: ListView.builder(
        // shrinkWrap: true,
        // physics: AlwaysScrollableScrollPhysics(),
        itemCount: following.length,
        itemBuilder: (context, index) {
          String followedUser = following[index];
          return ListTile(
            title: Text(followedUser),
          );
        },
      ),
    );
  }
}
