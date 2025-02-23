import 'package:flutter/material.dart';
import 'package:meds/screens/auth/signup/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

/// Model to hold the details of each instruction card.
class InstructionCard {
  final String title;
  final String iconPath;
  final String description;

  InstructionCard({
    required this.title,
    required this.iconPath,
    required this.description,
  });
}

class InstructionSlider extends StatefulWidget {
  const InstructionSlider({super.key});

  @override
  _InstructionSliderState createState() => _InstructionSliderState();
}

class _InstructionSliderState extends State<InstructionSlider> {
  int _currentIndex = 0;
  late PageController _pageController;

  // List of instruction cards.
  final List<InstructionCard> _instructionCards = [
    InstructionCard(
      title: 'Welcome',
      iconPath: 'assets/images/welcome_icon.png',
      description: 'Welcome to our app. Let us show you how it works.',
    ),
    InstructionCard(
      title: 'Feature One',
      iconPath: 'assets/images/feature1_icon.png',
      description: 'Discover feature one that helps you manage tasks efficiently.',
    ),
    InstructionCard(
      title: 'Feature Two',
      iconPath: 'assets/images/feature2_icon.png',
      description: 'Explore feature two for seamless communication and collaboration.',
    ),
    // Add more cards as needed.
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _checkUserSeenInstructions();
  }

  // Check if user has seen the instructions before.
  _checkUserSeenInstructions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasSeenInstructions = prefs.getBool('hasSeenInstructions');
    if (hasSeenInstructions == true) {
      // Do nothing; the user stays on the instruction page until they finish.
    }
  }

  // Save that the user has seen the instructions.
  _markInstructionsAsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenInstructions', true);
  }

  // Move to the next page or sign up based on the current index.
  _onNextPressed() {
    if (_currentIndex == _instructionCards.length - 1) {
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
      backgroundColor: Colors.grey[100], // Extremely light background.
      body: SafeArea(
        child: Column(
          children: [
            // Skip button at the top right.
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: AppFonts.body.copyWith(
                      color: Colors.green[800], // Dark green color.
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Instruction card slider.
            Expanded(
              flex: 7,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _instructionCards.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildCard(_instructionCards[index]);
                },
              ),
            ),
            // Next / Sign Up button.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _currentIndex == _instructionCards.length - 1 ? 'Sign Up' : 'Next',
                    style: AppFonts.button.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an elevated instruction card that covers at least 50% of the screen height.
  Widget _buildCard(InstructionCard card) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white, // Light card background.
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title text.
                Text(
                  card.title,
                  style: AppFonts.heading.copyWith(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Icon/Image.
                Image.asset(
                  card.iconPath,
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                // Description paragraph.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    card.description,
                    style: AppFonts.body.copyWith(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
