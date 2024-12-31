import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/ngo/admin/admin_dashboard_page.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

class NGODashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NGO Dashboard',
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

            // Admin Section
            _buildRoleCard(
              context,
              title: 'Admin',
              description: 'Manage donations and view reports.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDashboardPage(),
                  ),
                );
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

            // Pharmacist Section
            _buildRoleCard(
              context,
              title: 'Pharmacist',
              description: 'Manage donated medicines and stock.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PharmacistDashboard(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, {required String title, required String description, required VoidCallback onPressed}) {
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

// Placeholder Pages for Admin, Deliverer, and Pharmacist Dashboards
class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Text(
          'Admin functionalities will be implemented here',
          style: AppFonts.body.copyWith(color: AppColors.textColor),
        ),
      ),
    );
  }
}

class DelivererDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deliverer Dashboard',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Text(
          'Deliverer functionalities will be implemented here',
          style: AppFonts.body.copyWith(color: AppColors.textColor),
        ),
      ),
    );
  }
}

class PharmacistDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pharmacist Dashboard',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Text(
          'Pharmacist functionalities will be implemented here',
          style: AppFonts.body.copyWith(color: AppColors.textColor),
        ),
      ),
    );
  }
}
