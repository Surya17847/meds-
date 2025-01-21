import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';
import 'package:meds/screens/giver/donor_options_page.dart';

class DonationConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirmation Page",
          style: TextStyle(
            fontFamily: AppFonts.secondaryFont,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: AppColors.textColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            color: AppColors.backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: Text(
                      "Thanks For Donating to us!",
                      style: TextStyle(
                        fontFamily: AppFonts.secondaryFont,
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DonorOptionsPage()),
                      );
                    },
                    child: Text("Back", style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimaryColor,)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}