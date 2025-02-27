import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

class NGOActionConfirmationPage extends StatelessWidget {
  final bool isApproved; // This will determine if it's approval or rejection

  // Constructor to pass the action type (approve or reject)
  NGOActionConfirmationPage({required this.isApproved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isApproved ? 'Medicine Approved' : 'Medicine Rejected',
          style: AppFonts.heading.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        backgroundColor: isApproved ? AppColors.successColor : AppColors.errorColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isApproved ? Icons.check_circle_outline : Icons.cancel_outlined,
              size: 100,
              color: isApproved ? AppColors.successColor : AppColors.errorColor,
            ),
            SizedBox(height: 20),
            Text(
              isApproved
                  ? 'You have successfully approved the donation.'
                  : 'You have rejected the donation request.',
              style: AppFonts.body.copyWith(
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the main dashboard or medicine listing page
                Navigator.pop(context);
              },
              child: Text(
                'Go back to Dashboard',
                style: AppFonts.button.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
