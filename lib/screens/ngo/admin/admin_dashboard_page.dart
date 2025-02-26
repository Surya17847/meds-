import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/ngo/admin/request_medicine_page.dart';
import 'package:meds/screens/ngo/admin/check_donation_status.dart';
import 'package:meds/screens/ngo/admin/view_donated_medicine.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
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
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              'Welcome to the Admin Dashboard',
              style: AppFonts.heading.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 20),

            // List of Dashboard Options as Cards
            _buildDashboardCard(
              context: context,
              imagePath: 'assets/images/medicines.png',
              title: 'View Donated Medicines',
              page: ViewDonatedMedicinesPage(),
            ),
            _buildDashboardCard(
              context: context,
              imagePath: 'assets/images/request.png',
              title: 'Request for Medicines',
              page: RequestForMedicinesPage(),
            ),
            _buildDashboardCard(
              context: context,
              imagePath: 'assets/images/donation_status.png',
              title: 'Check Donation Status',
              page: CheckDonationStatusPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required String imagePath,
    required String title,
    required Widget page,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16), // Adds spacing between cards
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card Image
            Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppFonts.body.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 10),
            // Button
            SizedBox(
              width: double.infinity, // Full-width button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                },
                child: Text('Open', style: AppFonts.button),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimaryColor,
                  foregroundColor: AppColors.buttonTextColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
