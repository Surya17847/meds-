import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meds/screens/home_screen.dart';
import 'package:meds/screens/auth/signup/signup_page.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';
import 'package:meds/screens/auth/signup/buttons.dart';
import '../LoginWithGoogle/google_auth.dart';
import '../PasswordForgot/forgot_password.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  Future<void> logInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      // Force the account chooser to appear by signing out first
      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in process
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Check if the user already exists in Firestore
        var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          // User found, navigate to the HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // User does not exist, prompt to sign up
          print("Please Sign Up First!");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User not found in database. Please sign up first.")),
          );
        }
      }
    } catch (e) {
      print("Google sign-in failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed. Please try again.")),
      );
    }
  }


  Future<void> loginUserWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      print(userCredential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Page',
          style: AppFonts.heading.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Prevent overflow by allowing scrolling
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50), // Padding from the top

            // Add the Meds icon image
            Image.asset(
              'assets/images/meds_icon.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 30),

            // Email Input Field
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: AppFonts.body.copyWith(color: Colors.black), // Hint text color set to black
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              style: AppFonts.body.copyWith(color: Colors.black), // Text color set to black
            ),
            const SizedBox(height: 15),

            // Password Input Field
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: AppFonts.body.copyWith(color: Colors.black), // Hint text color set to black
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              obscureText: true,
              style: AppFonts.body.copyWith(color: Colors.black), // Text color set to black
            ),
            const SizedBox(height: 20),

            // Forgot Password
            const ForgotPassword(),

            // Custom Login Button
            MyButtons(
              onTap: loginUserWithEmailAndPassword,
              text: "Log In",
            ),

            // Divider and SignUp Option
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0), // Added padding to the SignUp row
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centering the "Don't have an account?" row
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Google Login Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: logInWithGoogle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.account_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Log In with Google",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}