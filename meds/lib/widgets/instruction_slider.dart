import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/screens/auth/signup/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

class InstructionSlider extends StatefulWidget {
  const InstructionSlider({super.key});

  @override
  _InstructionSliderState createState() => _InstructionSliderState();
}

class _InstructionSliderState extends State<InstructionSlider> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _checkUserSeenInstructions();
  }

  // Check if user has seen the instructions before
  _checkUserSeenInstructions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasSeenInstructions = prefs.getBool('hasSeenInstructions');
    if (hasSeenInstructions == true) {
      // Do nothing, stay on the instruction page until they finish
    }
  }

  // Save that user has seen the instructions
  _markInstructionsAsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenInstructions', true);
  }

  // Move to next page or sign up based on index
  _onNextPressed() {
    if (_currentIndex == 2) {
      _markInstructionsAsSeen();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    // Skip to Sign Up without marking as seen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: AppFonts.body.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold, // Make 'Skip' text bold
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 7,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  _buildPage('assets/images/instruction1.png', 'Instruction 1'),
                  _buildPage('assets/images/instruction2.png', 'Instruction 2'),
                  _buildPage('assets/images/instruction3.png', 'Instruction 3'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: _onNextPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimaryColor, // Using new primary button color
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded button
                      ),
                    ),
                    child: Text(
                      _currentIndex == 2 ? 'Sign Up' : 'Next',
                      style: AppFonts.button.copyWith(color: AppColors.buttonTextColor), // White text on button
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String imagePath, String instructionText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 350, // Increased the width of the image
          height: 350, // Increased the height of the image
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 16),
        Text(
          instructionText,
          style: AppFonts.body.copyWith(color: AppColors.whiteColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}


/*
Code with shared_preferences
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meds/screens/auth/signup/signup_page.dart'; // Assuming you have a SignUpPage
import 'package:meds/screens/home_screen.dart'; // Assuming you have a HomeScreen

class InstructionsSlider extends StatefulWidget {
  const InstructionsSlider({super.key});

  @override
  _InstructionsSliderState createState() => _InstructionsSliderState();
}

class _InstructionsSliderState extends State<InstructionsSlider> {
  int currentPage = 0;

  // Function to mark instructions as seen
  _markInstructionsAsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenInstructions', true);
  }

  // Function to handle the next button click
  void _nextPage() {
    setState(() {
      if (currentPage < 2) {
        currentPage++;
      } else {
        // Mark instructions as seen when user reaches the last page
        _markInstructionsAsSeen();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()), // Navigate to SignUpPage or HomeScreen
        );
      }
    });
  }

  // Function to handle the skip button click
  void _skipInstructions() {
    _markInstructionsAsSeen();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()), // Skip to SignUpPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: _skipInstructions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Your instructions slider content here
          Expanded(
            child: PageView(
              controller: PageController(initialPage: currentPage),
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              children: [
                // Add your instruction pages here
                Page1(),
                Page2(),
                Page3(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _nextPage,
              child: Text(currentPage == 2 ? 'Sign Up' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}

 */
