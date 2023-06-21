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

  void navigateToChatPage(
      BuildContext context, String userId, String email, String name) {
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
      'MessangerPro',
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _userEmail() {
    return Text(
      'Mohammed Alsharif', // Set user name here
      style: TextStyle(
        color: Color.fromRGBO(88, 40, 65, 1), // Set the desired color
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text(
        'Sign Out',
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Color.fromRGBO(88, 40, 65, 1)), // Set the desired color
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(200, 48), // Increase button size
        ),
      ),
    );
  }

  Widget _buildChatButton(
      BuildContext context, String userId, String email, String name) {
    if (userId == user?.uid) {
      return Container(); // Don't show button for logged-in user
    }
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(88, 40, 65, 1), // Set the desired color
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            navigateToChatPage(context, userId, email, name);
          },
          icon: Icon(
            Icons.chat_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: _title(),
          backgroundColor:
              Color.fromRGBO(88, 40, 65, 1), // Apply the desired color
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(88, 40, 65, 1), // Apply the desired color
                Colors.indigo,
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _userEmail(),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        _buildChatButton(
                          context,
                          'mYyeyAN4WpSQkeELqSG3oFahU9h2',
                          'ahmad safwan',
                          'Ahmad Safwan',
                        ),
                        _buildChatButton(
                          context,
                          'L6igQ7I3zrMBKPloD2CycczOu0p2',
                          'mohammedalsharrif7@gmail.com',
                          'Mohammed Alsharif',
                        ),
                        _buildChatButton(
                          context,
                          'eHWgoDkMRbc2r51MEIoY1zO33c42',
                          'tawfikjaf@gmail.com',
                          'Tawfik',
                        ),
                        _buildChatButton(
                          context,
                          'IqlNfzQYwIh3mrGoz3wgGcuxhbO2',
                          'didouhs41@gmail.com',
                          'Hadi',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _signOutButton(),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: _title(),
          backgroundColor:
              Color.fromRGBO(88, 40, 65, 1), // Apply the desired color
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
