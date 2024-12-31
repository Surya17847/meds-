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
              child: ElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.google),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Changed to green color for Google login
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50), // Increase width of the Google button
                ),
                onPressed: () async {
                  await FirebaseServices().signInWithGoogle();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
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
    );
  }
}
