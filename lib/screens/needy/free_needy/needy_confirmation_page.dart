import 'package:flutter/material.dart';
import 'package:meds/screens/needy/recipients_home_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class OrderConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Confirmed',
          style: AppFonts.headline.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppColors.successColor,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Your order has been confirmed!',
              style: AppFonts.body.copyWith(color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for placing your order. We will notify you once the medicine is ready for delivery or pickup.',
              style: AppFonts.body,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // Button to go back to Home Screen
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}
