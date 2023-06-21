import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Functions {
  static void updateAvailability() {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final data = {
      'name': auth.currentUser!.displayName ?? auth.currentUser!.email,
      'date_time': DateTime.now(),
      'email': auth.currentUser!.email,
    };
    try {
      firestore.collection('Users').doc(auth.currentUser!.uid).set(data);
    } catch (e) {
      print(e);
    }
  }
}
