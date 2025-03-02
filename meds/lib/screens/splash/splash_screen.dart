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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // Show splash for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Get current user
    User? user = FirebaseAuth.instance.currentUser;

    // Access SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasSeenInstructions = prefs.getBool('hasSeenInstructions') ?? false;
    bool? isLoggedOut = prefs.getBool('isLoggedOut') ?? false;

    if (user != null && !isLoggedOut) {
      // User is logged in and not logged out explicitly
      if (hasSeenInstructions) {
        // Navigate to HomeScreen if instructions are already seen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Navigate to InstructionSlider if instructions haven't been seen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InstructionSlider()),
        );
      }
    } else {
      // If user is not logged in or explicitly logged out, show instructions
      prefs.remove('isLoggedOut'); // Clear logout status
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InstructionSlider()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  fontSize: 36,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Medicine Exchange and Distribution System",
                style: AppFonts.body.copyWith(
                  fontSize: 16,
                  color: AppColors.whiteColor.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
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
