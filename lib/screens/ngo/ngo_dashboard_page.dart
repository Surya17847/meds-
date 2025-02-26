import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/ngo/admin/admin_dashboard_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/screens/ngo/pharmacist/pharmacist_dashboard.dart';  // Import the Pharmacist Dashboard page
import 'package:meds/screens/ngo/deliverer/deliverer_dashboard.dart';  // Import the Deliverer Dashboard page

// 1. Define the Authorized Admin Emails
const List<String> authorizedAdmins = [
  "2022.harsh.patil@ves.ac.in",
  "harshpatil1099@gmail.com",
  "2022.suryanarayan.panigrahy@ves.ac.in",
  "2022.hemant.satam@ves.ac.in",
  "2022.gaurav.gupta@ves.ac.in"
];

// 2. Check if the logged-in user is an authorized admin
Future<bool> isAdminUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null && user.email != null && authorizedAdmins.contains(user.email)) {
    return true; // User is an admin
  }
  return false; // User is not authorized
}

class NGODashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MEDS Co-ordinators',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.whiteColor),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome to the NGO Dashboard',
              style: AppFonts.heading.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 20),
            Text(
              'Select your role:',
              style: AppFonts.body.copyWith(color: AppColors.textColorSecondary),
            ),
            SizedBox(height: 20),

            // Admin Section with email verification
            _buildRoleCard(
              context,
              title: 'Admin',
              description: 'Manage donations and view reports.',
              onPressed: () async {
                bool isAdmin = await isAdminUser();
                if (isAdmin) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminDashboardPage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Access Denied: You are not an admin")),
                  );
                }
              },
            ),
            SizedBox(height: 20),

            // Deliverer Section
            _buildRoleCard(
              context,
              title: 'Deliverer',
              description: 'Track and manage deliveries.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DelivererDashboard(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Pharmacist Section with admin access check
            _buildRoleCard(
              context,
              title: 'Pharmacist',
              description: 'Manage donated medicines and stock.',
              onPressed: () async {
                bool isAdmin = await isAdminUser();
                if (isAdmin) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PharmacistDashboard(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Access Denied: You are not authorized")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
      BuildContext context, {
        required String title,
        required String description,
        required VoidCallback onPressed,
      }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: AppFonts.heading.copyWith(color: AppColors.textColor),
        ),
        subtitle: Text(
          description,
          style: AppFonts.body.copyWith(color: AppColors.textColorSecondary),
        ),
        trailing: Icon(Icons.arrow_forward, color: AppColors.secondaryColor),
        onTap: onPressed,
      ),
    );
  }
}
