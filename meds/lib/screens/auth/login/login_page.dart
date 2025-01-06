import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore integration
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:flutter/material.dart'; // Core UI components
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For Google Icon
import 'package:meds/screens/home_screen.dart'; // HomeScreen navigation
import 'package:meds/screens/auth/signup/signup_page.dart'; // SignUpPage navigation
import 'package:meds/utils/ui_helper/app_colors.dart'; // UI Colors
import 'package:meds/utils/ui_helper/app_fonts.dart'; // UI Fonts
import 'package:meds/screens/auth/signup/buttons.dart'; // Button widget
import '../LoginWithGoogle/google_auth.dart'; // Google Authentication Helper
import '../PasswordForgot/forgot_password.dart'; // Forgot Password Helper
import 'package:google_sign_in/google_sign_in.dart';

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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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

  // Login with Email and Password (with Firestore validation)
  Future<void> loginUserWithEmailAndPassword() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        final userExists = await checkUserExists(emailController.text.trim());
        if (!userExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account does not exist in Firestore.')),
          );
          return;
        }

        // Firebase Authentication to log in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Navigate to HomeScreen if login is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed.')),
        );
      }
    }
  }

  // Login with Google
  Future<void> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      // Force the account chooser to appear by signing out first
      await googleSignIn.signOut();
      final userCredential = await FirebaseServices().signInWithGoogle();

      if (userCredential == null || userCredential.user == null) {
        throw Exception('Google sign-in failed');
      }

      final userExists = await checkUserExists(userCredential.user!.email ?? '');
      if (!userExists) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName,
          'photoUrl': userCredential.user!.photoURL,
        });
      }

      // Navigate to HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login failed: $e')),
      );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // Meds icon
              Image.asset(
                'assets/images/meds_icon.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 30),

              // Email Input
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: AppFonts.body.copyWith(color: Colors.black),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
                style: AppFonts.body.copyWith(color: Colors.black),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 15),

              // Password Input
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: AppFonts.body.copyWith(color: Colors.black),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
                obscureText: true,
                style: AppFonts.body.copyWith(color: Colors.black),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your password' : null,
              ),
              const SizedBox(height: 20),

              // Forgot Password
              const ForgotPassword(),

              // Login Button
              MyButtons(
                onTap: loginUserWithEmailAndPassword,
                text: "Log In",
              ),

              // SignUp Option
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                child: ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.google),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: loginWithGoogle,
                  label: const Text(
                    "Continue with Google",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
