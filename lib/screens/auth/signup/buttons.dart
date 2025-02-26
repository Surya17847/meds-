import 'package:flutter/material.dart';
// Import app colors
import 'package:meds/utils/ui_helper/app_theme.dart';  // Import app fonts

class MyButtons extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const MyButtons({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  _MyButtonsState createState() => _MyButtonsState();
}

class _MyButtonsState extends State<MyButtons> {
  // Define state variable for hover effect
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;  // Set hover to true when mouse enters
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;  // Set hover to false when mouse exits
            });
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: ShapeDecoration(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              color: _isHovered ? Colors.grey[800] : Colors.black, // Change color on hover
              shadows: [
                if (_isHovered) // Add shadow effect when hovered
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: const Offset(0, 3), // Shadow position
                  ),
              ],
            ),
            child: Text(
              widget.text,
              style: AppFonts.button.copyWith(
                color: Colors.white,  // White text color
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/*
// Function for handling hover effect (Change button color on hover)
  void _onHover(BuildContext context, bool isHovered) {
    // For example, change the button color on hover
    if (isHovered) {
      // Change button's background color on hover
    } else {
      // Revert back to original background color
    }
  }

*/