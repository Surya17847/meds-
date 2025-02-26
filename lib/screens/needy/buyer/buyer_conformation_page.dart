import 'package:flutter/material.dart';
import 'package:meds/screens/needy/recipients_home_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class BuyerConformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: AppFonts.headline.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thank you for your purchase!',
              style: AppFonts.headline.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 20),
            Text(
              'Here are the details of your purchase:',
              style: AppFonts.body,
            ),
            SizedBox(height: 20),

            _buildDetailRow('Medicine:', 'Paracetamol'),
            _buildDetailRow('Quantity:', '2 boxes'),
            _buildDetailRow('Total Price:', 'Rs.30'),

            SizedBox(height: 30),

            // Button to go back to Home Screen
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => RecipientsHomePage()),
                    (Route<dynamic> route) => false, // Clears previous routes
                  );
                },
                child: Text('Go to Home', style: AppFonts.button),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimaryColor,
                  foregroundColor: AppColors.buttonTextColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: AppFonts.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            label,
            style: AppFonts.body.copyWith(color: AppColors.textColor),
          ),
          SizedBox(width: 10),
          Text(value, style: AppFonts.body),
        ],
      ),
    );
  }
}
