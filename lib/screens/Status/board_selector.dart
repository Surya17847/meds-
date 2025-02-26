import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'donated_medicines.dart';
import 'sold_medicines.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class BoardSelector extends StatefulWidget {
  const BoardSelector({super.key});

  @override
  State<BoardSelector> createState() => _BoardSelectorState();
}

class _BoardSelectorState extends State<BoardSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See Your Activities',
            style: AppFonts.headline.copyWith(color: AppColors.whiteColor)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BoxButton(
              label: "Donated Medicines",
              icon: FontAwesomeIcons.handHoldingHeart,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DonatedMed()),
                );
              },
            ),
            const SizedBox(height: 16),
            BoxButton(
              label: "Purchased Medicines",
              icon: Icons.shopping_cart,
              onTap: () {
                // Handle navigation
              },
            ),
            const SizedBox(height: 16),
            BoxButton(
              label: "Sold Medicines",
              icon: FontAwesomeIcons.moneyBillWave,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SelledMed()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BoxButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const BoxButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Light background color
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5.0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppColors.primaryColor, // Dark color for the icon
            ),
            const SizedBox(width: 16.0),
            Text(
              label,
              style: AppFonts.button.copyWith(color: AppColors.primaryColor), // Dark text color
            ),
          ],
        ),
      ),
    );
  }
}
