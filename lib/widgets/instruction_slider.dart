import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'instruction_card_widget.dart';
import 'instruction_data.dart';

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

  _checkUserSeenInstructions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasSeenInstructions = prefs.getBool('hasSeenInstructions');
    if (hasSeenInstructions == true) {
      // Do nothing; the user stays on the instruction page until they finish.
    }
  }

  _markInstructionsAsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenInstructions', true);
  }

  _onNextPressed() {
    if (_currentIndex == instructionCards.length - 1) {
      _markInstructionsAsSeen();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
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
      backgroundColor: AppColors.backgroundColor, // Use themed background color
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: AppFonts.body.copyWith(
                      color: AppColors.secondaryColor, // Themed secondary color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: PageView.builder(
                controller: _pageController,
                itemCount: instructionCards.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return InstructionCardWidget(card: instructionCards[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimaryColor, // Themed button color
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _currentIndex == instructionCards.length - 1 ? 'Let’s go!' : 'Next',
                    style: AppFonts.button.copyWith(color: AppColors.buttonTextColor),
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
