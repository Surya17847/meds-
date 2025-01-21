import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meds/screens/Status/Donated_med.dart';
import 'package:meds/screens/Status/Selled_med.dart';

class board_selector extends StatefulWidget {
  const board_selector({super.key});

  @override
  State<board_selector> createState() => _board_selectorState();
}

class _board_selectorState extends State<board_selector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See Your Activities',
            style: Theme.of(context).textTheme.headlineLarge),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
            const SizedBox(height: 16), // Spacing between buttons

            BoxButton(
              label: "Purchased Medicines",
              icon: Icons.shopping_cart,
              onTap: () {
                print("Button 3 tapped");
              },
            ),
            const SizedBox(height: 16), // Spacing between buttons

            BoxButton(
                label: "Selled Medicines",
                icon: FontAwesomeIcons.moneyBillWave,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SelledMed()),
                  );
                }),
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
          color: Colors.deepPurpleAccent,
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
              color: Colors.white,
            ),
            const SizedBox(width: 16.0), // Space between icon and text
            Text(
              label,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
