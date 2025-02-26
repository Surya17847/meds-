import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/needy/buyer/buyer_home_page.dart';
import 'package:meds/screens/needy/free_needy/needy_home_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class RecipientsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Get Medicine',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.whiteColor,
                fontFamily: AppFonts.primaryFont,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Buyer Card
                  Expanded(
                    child: Card(
                      color: AppColors.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // This container can be replaced with an image asset if needed
                            ),
                            Text(
                              'Buy medicines easily at the best prices.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textColor,
                                    fontFamily: AppFonts.primaryFont,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Buyer_Home_page()),
                                );
                              },
                              child: Text(
                                'Buy at best price',
                                style: TextStyle(fontFamily: AppFonts.primaryFont),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Needy Card
                  Expanded(
                    child: Card(
                      color: AppColors.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // Placeholder for an image asset
                            ),
                            Text(
                              'Access free medicines for those in need.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textColor,
                                    fontFamily: AppFonts.primaryFont,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NeedyHomePage()),
                                );
                              },
                              child: Text(
                                'Apply for free medicine',
                                style: TextStyle(fontFamily: AppFonts.primaryFont),
                              ),
                              style: ElevatedButton.styleFrom(
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
