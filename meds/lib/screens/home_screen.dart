import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/giver/donor_options_page.dart';
import 'package:meds/screens/needy/recipients_home_page.dart';
import 'package:meds/screens/ngo/ngo_dashboard_page.dart';
import 'package:meds/widgets/app_drawer.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';
import 'package:meds/widgets/chatbot_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEDS'),

        backgroundColor: AppColors.primaryColor, // Set AppBar color to primaryColor

        actions: [
          // Logout Icon in AppBar
          IconButton(
            icon: Icon(
              Icons.logout,
              color: AppColors.textColor, // Set color for logout icon
            ),
            onPressed: () async {
              // Show confirmation dialog
              bool? exit = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Log Out'),
                  content: const Text('Are you sure you want to exit?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Cancel logout
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop(true); // Proceed with logout
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );

              // If confirmed, redirect to LoginPage
              if (exit == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),

      backgroundColor: AppColors.backgroundColor, // Set background color to AppColors.backgroundColor
      drawer: Drawer(
        child: Container(
          color: AppColors.primaryColor, // Set Drawer background to primaryColor
          child: const AppDrawer(), // Add the App Drawer
        ),
      ),
      body: SingleChildScrollView( // Make the body scrollable

        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Welcome Message Row combined with AppBar (Green Background)
            Container(
              color: AppColors.primaryColor, // Use primaryColor for the welcome message
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  'Welcome to MEDS',
                  style: AppFonts.heading, // Use heading text style
                ),
              ),
            ),
            // Main Card for Giver, Donor, and NGO (1 in a row)
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Giver Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 8,
                    color: Colors.blue[100],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      onTap: () {
                        // Action for Giver Card
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DonorOptionsPage()),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.volunteer_activism,
                              size: 60,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 10, width: 160),
                            Text(
                              'Giver/Donor',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Spacing between cards// Spacing between cards
                  // Donor Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 8,
                    color: Colors.green[100],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      onTap: () {
                        // Action for Donor Card
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecipientsHomePage()),
                        );                      },
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.request_page,
                              size: 60,
                              color: Colors.green,
                            ),
                            SizedBox(height: 10, width: 160),
                            Text(
                              'Needy',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Spacing between cards
                  // NGO Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 8,
                    color: Colors.pink[100],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      onTap: () {
                        // Action for NGO Card
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NGODashboardPage()),
                        );                      },
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.group,
                              size: 60,
                              color: Colors.pink,
                            ),
                            SizedBox(height: 10, width: 160),
                            Text(
                              'NGO',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Extra spacing before button
            // Button for Instruction Slider

            // Extra spacing for better layout
          ],

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatbotScreen()),
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/ai_chat.gif'),
          radius: 40,
        ),

      ),
    );
  }

}
