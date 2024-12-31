import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/home_screen.dart';
import 'package:meds/utils/ui_helper/app_colors.dart'; // Import app colors
import 'package:meds/utils/ui_helper/app_fonts.dart'; // Import app fonts
import 'package:meds/screens/auth/signup/buttons.dart'; // Assuming MyButtons is reusable
import 'package:meds/screens/auth/LoginWithGoogle/google_auth.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const SignUpPage(),
  );
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signUpWithGoogle() async {
    await FirebaseServices().signInWithGoogle(); // Trigger Google account selection
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()), // Navigate to login page after successful sign-up
    );
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print(userCredential);
      print(userCredential.user?.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
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
          "SignUp Page",
          style: AppFonts.heading.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Prevent overflow by allowing scrolling
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50), // Padding from the top

              // Logo image
              Image.asset(
                'assets/images/meds_icon.png', // Make sure you have this image
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),

              // Email Input Field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.black), // Text hint color set to black
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
                  hintStyle: TextStyle(color: Colors.black), // Text hint color set to black
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
                obscureText: true,
                style: AppFonts.body.copyWith(color: Colors.black), // Text color set to black
              ),
              const SizedBox(height: 20),

              // Sign Up Button
              MyButtons(onTap: createUserWithEmailAndPassword, text: "Sign Up"),

              const SizedBox(height: 20),

              // Link to login page if already have an account
              GestureDetector(
                onTap: () {
                  Navigator.push(context, LoginPage.route());
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: AppFonts.body.copyWith(
                      color: AppColors.textColor,
                    ),
                    children: [
                      TextSpan(
                        text: 'Log In',
                        style: AppFonts.body.copyWith(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Google sign-up button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor, // Use custom primary color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: signUpWithGoogle, // Trigger Google Sign-In
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.account_circle, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Sign Up with Google",
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
      ),
    );
  }
}
