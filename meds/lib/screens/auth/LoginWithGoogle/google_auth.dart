import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meds/utils/constants.dart'; // Adjust the path based on your project structure

class FirebaseServices {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Use the Google Client ID from constants.dart
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: AppConstants.googleClientId, // Add your Client ID here
  );

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await auth.signInWithCredential(authCredential);
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error during email sign-in: $e');
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error during sign-up: $e');
    }
  }

  // Sign out of both Firebase and Google
  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      print('Error during sign-out: $e');
    }
  }
}
