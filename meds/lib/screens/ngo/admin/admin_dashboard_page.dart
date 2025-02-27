import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/ngo/admin/request_medicine_page.dart';
import 'package:meds/screens/ngo/admin/check_donation_status.dart';
import 'package:meds/screens/ngo/admin/view_donated_medicine.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

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
            SizedBox(height: 20),
            Text(
              'Welcome to the Admin Dashboard',
              style: AppFonts.heading.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 20),

            // View Donated Medicines
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewDonatedMedicinesPage(),
                  ),
                );
              },
              child: Text(
                'View Donated Medicines',
                style: AppFonts.button,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),

            // Request for Medicines
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestForMedicinesPage(),
                  ),
                );
              },
              child: Text(
                'Request for Medicines',
                style: AppFonts.button,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),

            // Check Donation Status
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckDonationStatusPage(),
                  ),
                );
              },
              child: Text(
                'Check Donation Status',
                style: AppFonts.button,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
