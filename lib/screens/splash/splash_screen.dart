import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/widgets/instruction_slider.dart';
import 'package:meds/screens/home_screen.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Set status bar content color to dark
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Makes status bar background transparent
        statusBarIconBrightness: Brightness.dark, // Set the status bar icons to dark
        statusBarBrightness: Brightness.light, // Set the status bar text to dark (use light for dark text)
      ),
    );

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasSeenInstructions = prefs.getBool('hasSeenInstructions') ?? false;
    bool? isLoggedOut = prefs.getBool('isLoggedOut') ?? false;

    if (user != null && !isLoggedOut) {
      if (hasSeenInstructions) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InstructionSlider()),
        );
      }
    } else {
      prefs.remove('isLoggedOut');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InstructionSlider()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient Background using Theme Colors
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.whiteColor, AppColors.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Centered Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Logo
                  Image.asset(
                    'assets/images/meds_app_icon.png',
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 20),

                  // App Subtitle
                  Text(
                    "Bridging Surplus Need, Reducing waste",
                    style: AppFonts.body.copyWith(
                      fontSize: 22,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Loading Indicator
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    strokeWidth: 2.5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
