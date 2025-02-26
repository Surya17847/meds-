import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/screens/giver/donor/donor_options_page.dart';

class DonationConfirmationPage extends StatelessWidget {
  final Map<String, dynamic> medicine;
  DonationConfirmationPage({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donation Confirmation", style: AppFonts.heading),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildThankYouMessage(),
              SizedBox(height: 20),
              _buildMedicineDetails(),
              SizedBox(height: 20),
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThankYouMessage() {
    return Text(
      "Thank you for donating!",
      style: AppFonts.caption,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMedicineDetails() {
    return Card(
      color: AppColors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailText("Medicine Name", medicine['MedicineName']),
            _buildDetailText("Strength", medicine['Strength']),
            _buildDetailText("Quantity", medicine['Quantity']),
            _buildDetailText("Expiration Date", medicine['ExpirationDate']),
            _buildDetailText("Manufacturer", medicine['Manufacturer']),
            _buildDetailText("Notes", medicine['Notes'] ?? 'No Notes Provided'),
            if (medicine['ImagePath']?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.file(File(medicine['ImagePath']), width: 100, height: 100, fit: BoxFit.cover),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        "$label: ${value ?? 'Unknown'}",
        style: AppFonts.body,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DonorOptionsPage()),
          );
        },
        child: Text("Back", style: AppFonts.button),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimaryColor,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        ),
      ),
    );
  }
}
