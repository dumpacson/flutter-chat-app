import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/auth.dart';
import 'package:chat_app/pages/chatPage1.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  void navigateToChatPage(BuildContext context, String userId, String email, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          userId: userId,
          email: email,
          name: name,
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Firebase Auth',
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        onPressed: signOut,
        child: const Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF582841)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _chatButton(BuildContext context, String userId, String email, String name) {
    if (userId == user?.uid) {
      // If the button corresponds to the logged-in user, don't show the button
      return Container();
    }
    return ElevatedButton(
      onPressed: () {
        navigateToChatPage(context, userId, email, name);
      },
      child: Text(
        'Chat with $name',
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF582841)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      // If a user is logged in
      return Scaffold(
        appBar: AppBar(
          title: _title(),
          backgroundColor: Color(0xFF582841),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          color: Color(0xFFEFEFEF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _userUid(),
              SizedBox(height: 20),
              _chatButton(
                context,
                'mYyeyAN4WpSQkeELqSG3oFahU9h2',
                'ahmadnorsafwan@gmail.com',
                'Ahmad Safwan',
              ),
              SizedBox(height: 20),
              _chatButton(
                context,
                'L6igQ7I3zrMBKPloD2CycczOu0p2',
                'mohammedalsharrif7@gmail.com',
                'Mohammed',
              ),
              SizedBox(height: 20),
              _chatButton(
                context,
                'eHWgoDkMRbc2r51MEIoY1zO33c42',
                'tawfikjaf@gmail.com',
                'Tawfek',
              ),
              SizedBox(height: 20),
              _chatButton(
                context,
                'IqlNfzQYwIh3mrGoz3wgGcuxhbO2',
                'didouhs41@gmail.com',
                'Abdelhadi',
              ),
              SizedBox(height: 100), // Add space of 100 pixels
              _signOutButton(),
            ],
          ),
        ),
      );
    } else {
      // If no user is logged in
      return Scaffold(
        appBar: AppBar(
          title: _title(),
          backgroundColor: Color(0xFF582841),
        ),
        body: Center(
          child: Text(
            'Please log in to access the home page.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }
  }
}
