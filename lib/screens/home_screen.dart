import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/giver/donor/donor_options_page.dart';
import 'package:meds/screens/needy/recipients_home_page.dart';
import 'package:meds/screens/ngo/ngo_dashboard_page.dart';
// import 'package:meds/widgets/instruction_slider.dart';
import 'package:meds/widgets/app_drawer.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to MEDS!!',
          style: AppFonts.heading.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.logout, color: Colors.white),
          //   onPressed: () async {
          //     bool? exit = await showDialog<bool>(
          //       context: context,
          //       builder: (context) => AlertDialog(
          //         title: Text('Log Out', style: AppFonts.heading),
          //         content: Text('Are you sure you want to exit?', style: AppFonts.body),
          //         actions: [
          //           TextButton(
          //             onPressed: () => Navigator.of(context).pop(false),
          //             child: Text('Cancel', style: AppFonts.body),
          //           ),
          //           TextButton(
          //             onPressed: () async {
          //               await FirebaseAuth.instance.signOut();
          //               Navigator.of(context).pop(true);
          //               Navigator.pushReplacement(
          //                 context,
          //                 MaterialPageRoute(builder: (context) => const LoginPage()),
          //               );
          //             },
          //             child: Text('Yes', style: AppFonts.body.copyWith(fontWeight: FontWeight.bold)),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCard(context, 'Send Medicines', Icons.volunteer_activism, AppColors.primaryColor, DonorOptionsPage()),
            const SizedBox(height: 20),
            _buildCard(context, 'Acquire medicines', Icons.request_page, AppColors.successColor, RecipientsHomePage()),
            const SizedBox(height: 20),
            _buildCard(context, 'For Co-ordinators', Icons.group, AppColors.secondaryColor, NGODashboardPage()),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
        child: SizedBox(
          width: 250,
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 10),
              Text(title, style: AppFonts.headline.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
