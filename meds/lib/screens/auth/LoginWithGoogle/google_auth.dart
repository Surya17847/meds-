import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meds/utils/constants.dart'; // Adjust the path based on your project structure

class FirebaseServices {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Ensure that the correct Google Client ID is passed here
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: AppConstants.googleClientId, // Your OAuth 2.0 client ID (ensure it's correct)
    scopes: ['email'], // You can add more scopes as needed (e.g., 'profile', 'openid')
  );

  // Check if the user exists in Firestore
  Future<bool> checkUserExists(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Sign out any previously signed-in account
      await googleSignIn.signOut();

      // Start the Google sign-in process
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Sign in with the Google credentials
        return await auth.signInWithCredential(authCredential);
      } else {
        print('Google sign-in was cancelled by the user.');
        return null;
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } catch (e) {
      print('Error during email sign-in: $e');
      return null;
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } catch (e) {
      print('Error during sign-up: $e');
      return null;
    }
  }

  // Sign out of both Firebase and Google
  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
      print('User successfully signed out.');
    } catch (e) {
      print('Error during sign-out: $e');
    }
  }
}
