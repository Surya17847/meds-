import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/giver/donor/donor_dashboard.dart';
import 'package:meds/screens/giver/seller/seller_dashboard.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class DonorOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Send Medicines',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontFamily: AppFonts.primaryFont, // Apply custom font here
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Donor card
                  Expanded(
                    child: Card(
                      color: AppColors.backgroundColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100,
                              color: Colors.grey[300], // Placeholder for image
                            ),
                            Text(
                              'Donate your unused medicines to help those in need.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textColor,
                                    fontFamily: AppFonts.primaryFont, // Apply custom font here
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DonorDashboard()),
                                );
                              },
                              child: Text(
                                'Donate Medicines',
                                style: TextStyle(
                                fontFamily: AppFonts.primaryFont, // Correctly apply the font family here
                               ),
                              ),
                             
                              style: ElevatedButton.styleFrom(
                              //   fontFamily: AppFonts.primaryFont, // Apply custom font here
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Seller card
                  Expanded(
                    child: Card(
                      color: AppColors.backgroundColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100,
                              color: Colors.grey[300], // Placeholder for image
                            ),
                            Text(
                              'Sell surplus medicines at great value.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textColor,
                                    fontFamily: AppFonts.primaryFont, // Apply custom font here
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SellerDashboard()),
                                );
                              },
                              child: Text(
                                'Sell Medicines',
                                style: TextStyle(
                                fontFamily: AppFonts.primaryFont, // Correctly apply the font family here
                               ),
                              ),
                             
                              style: ElevatedButton.styleFrom(
                              //   fontFamily: AppFonts.primaryFont, // Apply custom font here
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: AppColors.whiteColor,
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
          ],
        ),
      ),
    );
  }
}
