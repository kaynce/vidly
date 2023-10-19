import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainBloc {
  // Singleton pattern to ensure a single instance of MainBloc.
  static final MainBloc _instance = MainBloc._internal();

  factory MainBloc() {
    return _instance;
  }

  MainBloc._internal();

  // Firebase initialization method.
  Future<void> initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      // Replace with your actual Firebase config options.
      options: const FirebaseOptions(
        apiKey: "AIzaSyBokeZtPD-49EMWYWvHHxPmVO9CcMNSphg",
        appId: "1:457503765928:android:82c64e974855827633599d",
        messagingSenderId: "XXX",
        projectId: "vidly-4ffa5",
      ),
    );
    // Create a Firestore instance.
    final firestore = FirebaseFirestore.instance;

    // Check if the Firestore instance is initialized.
    if (firestore.app == null) {
      print("Firestore is not initialized.");
    } else {
      print("Firestore is initialized.");
    }
  }

  // Firestore stream method.
  Stream<QuerySnapshot> getFirestoreStream() {
    return FirebaseFirestore.instance.collection('tblMovie').snapshots();
  }
}
