import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vidly/views/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
      try {
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        // Check if the user cancelled the sign-in process
        if (googleUser == null) {
          return null; // Return null or handle the cancellation accordingly
        }

        // Obtain the user's name and photo URL from their Google account
        final String? userName = googleUser.displayName;
        final String? userPhotoUrl = googleUser.photoUrl;

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase using the credential
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Check if the sign-in was successful
        if (userCredential.user != null) {
          final userEmail = userCredential.user!.email;
          if (userEmail != null) {
            // User is logged in successfully, print the name and email
            print('User logged in with name: $userName and email: $userEmail');

            // Store user information in Firestore
            final firestore = FirebaseFirestore.instance;
            await firestore.collection('tblActiveUsers').doc(userEmail).set({
              'strName': userName, // Store the user's name
              'strEmail': userEmail,
              'strPhotoUrl': userPhotoUrl, // Store the user's photo URL
              // Add other user data as needed
            });

             await firestore.collection('tblUsers').doc(userEmail).set({
              'strName': userName, 
              'strEmail': userEmail,
              'strPhotoUrl': userPhotoUrl, 
              'intSupporter': 0,
              'isVerified': false,
              'dtmDateCreaetd': FieldValue.serverTimestamp(), 
              // Add other user data as needed
            });

            // Navigate to the next screen (replace 'LoginScreen()' with your destination screen)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeView(), // Replace 'HomeScreen()' with your destination screen
              ),
            );
          }
        }

        return userCredential;
      } catch (error) {
        print('Error signing in with Google: $error');
        return null; // Handle the error appropriately, e.g., show an error message to the user
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                signInWithGoogle(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Login with Google',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
