import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/needy/buyer/buyer_home_page.dart';
import 'package:meds/screens/needy/free_needy/needy_home_page.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

import '../../utils/ui_helper/app_colors.dart';

class RecipientsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Needy Dashboard',
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Buyer_Home_page()),
                  );
                },
                child: Text('Buyer'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NeedyHomePage()),
                  );
                },
                child: Text('Needy'),
              ),
            ],
          ),
        ));
  }
}