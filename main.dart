// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  HomePage({Key? key}) : super(key: key);

  void _signIn(BuildContext context) async {
  try {
    // Sign in with Firebase Authentication
    UserCredential userCredential = await _auth.signInAnonymously();
    User? user = userCredential.user;
    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ChatPage(),
        ),
      );
    }
  } catch (e) {
    print('Error signing in: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _signIn(context),
          child: const Text('Sign In'),
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
    _configureLocalNotifications();
  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages here
      _showLocalNotification(message.notification?.title ?? 'No title', message.notification?.body ?? 'No body');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle background messages here
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
    });

    _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
    );
  }

  void _configureLocalNotifications() {
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: _onNotification);
}

void _onNotification(NotificationResponse? notification) {
  // Handle the notification interaction here
  print('Notification interaction: ${notification?.payload}');
}

  Future _onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    // Navigate to a specific screen when the notification is tapped
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
  }

  void _showLocalNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'chat_app_channel', // Change the channel ID to your desired value
    'Chat App Notifications', // Change the channel name to your desired value
    // 'Channel for Chat App notifications', // Change the channel description to your desired value
    importance: Importance.max,
    priority: Priority.high,
  );
  var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  _flutterLocalNotificationsPlugin.show(
    0,
    'New Message', // Replace with your notification title
    'You have a new message', // Replace with your notification message
    platformChannelSpecifics,
  );
}

  void _sendMessage(String message) {
    // Implement your logic to send the message
    // For demonstration purposes, we'll print it to the console
    print('Sending message: $message');

    // Clear the input field after sending the message
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // Implement your logic to display the chat messages
              // For demonstration purposes, we'll display a Text widget
              child: const Center(
                child: Text('Chat messages will appear here'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_textEditingController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
