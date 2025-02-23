import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/widgets/instruction_slider.dart';
import 'package:meds/screens/home_screen.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.secondaryColor],
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
                  Image.asset(
                    'assets/images/meds_start.png',
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "MEDS",
                    style: AppFonts.heading.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Medicine Exchange and Distribution System",
                    style: AppFonts.body.copyWith(
                      fontSize: 16,
                      color: AppColors.whiteColor.withValues(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  
                  // Loading Indicator
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

/*
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:meds/widgets/instruction_slider.dart';
// import 'package:meds/screens/home_screen.dart';
// import 'package:meds/utils/ui_helper/app_colors.dart';
// import 'package:meds/utils/ui_helper/app_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateAfterSplash();
//   }
//
//   Future<void> _navigateAfterSplash() async {
//     await Future.delayed(const Duration(seconds: 2)); // Show splash for 2 seconds
//     User? user = FirebaseAuth.instance.currentUser;
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? hasSeenInstructions = prefs.getBool('hasSeenInstructions') ?? false;
//     bool? isLoggedOut = prefs.getBool('isLoggedOut') ?? false;  // Track if user has logged out
//
//     // If user has logged out, show the InstructionSlider
//     if (isLoggedOut == true) {
//       prefs.remove('isLoggedOut');  // Clear logout status
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const InstructionSlider()),
//       );
//     } else {
//       if (user != null) {
//         // If user is logged in, check if they have seen instructions
//         if (hasSeenInstructions) {
//           // Go to HomeScreen if instructions are already seen
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const HomeScreen()),
//           );
//         } else {
//           // Show the InstructionSlider if instructions haven't been seen
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const InstructionSlider()),
//           );
//         }
//       } else {
//         // If no user is logged in, show the InstructionSlider
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const InstructionSlider()),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: AppColors.primaryColor, // Use primary color from AppColors
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/images/meds_start.png',
//                 height: 120,
//                 width: 120,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "MEDS",
//                 style: AppFonts.heading.copyWith(
//                   fontSize: 36,
//                   color: AppColors.whiteColor,
//                 ), // Use AppFonts for heading
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 "Medicine Exchange and Distribution System",
//                 style: AppFonts.body.copyWith(
//                   fontSize: 16,
//                   color: AppColors.whiteColor.withOpacity(0.9),
//                 ), // Use AppFonts for body text
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

*/
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:meds/widgets/instruction_slider.dart';
// import 'package:meds/screens/home_screen.dart';
// import 'package:meds/utils/ui_helper/app_colors.dart';
// import 'package:meds/utils/ui_helper/app_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateAfterSplash();
//   }
//
//   Future<void> _navigateAfterSplash() async {
//     await Future.delayed(const Duration(seconds: 2)); // Show splash for 2 seconds
//     User? user = FirebaseAuth.instance.currentUser;
//
//     // Check if user is logged in
//     if (user != null) {
//       // Check if user has seen instructions
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       bool? hasSeenInstructions = prefs.getBool('hasSeenInstructions') ?? false;
//
//       if (hasSeenInstructions) {
//         // If instructions are already seen, go to HomeScreen directly
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       } else {
//         // Otherwise, show the InstructionSlider
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const InstructionSlider()),
//         );
//       }
//     } else {
//       // If no user is logged in, show the SignUpPage or InstructionsSlider
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const InstructionSlider()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: AppColors.primaryColor, // Use primary color from AppColors
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/images/meds_start.png',
//                 height: 120,
//                 width: 120,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "MEDS",
//                 style: AppFonts.heading.copyWith(
//                   fontSize: 36,
//                   color: AppColors.whiteColor,
//                 ), // Use AppFonts for heading
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 "Medicine Exchange and Distribution System",
//                 style: AppFonts.body.copyWith(
//                   fontSize: 16,
//                   color: AppColors.whiteColor.withOpacity(0.9),
//                 ), // Use AppFonts for body text
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
