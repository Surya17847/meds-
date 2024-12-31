import 'package:flutter/material.dart';
import 'package:meds/screens/giver/seller/sell_medicines.dart';
import 'package:meds/utils/ui_helper/app_colors.dart'; // Importing app_colors.dart
import 'package:meds/utils/ui_helper/app_fonts.dart'; // Importing app_fonts.dart

class SellerDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> medicines = [
    {
      'name': 'Paracetamol',
      'dosageForm': 'Tablet',
      'strength': '500mg',
      'quantityAvailable': 10,
      'expiryDate': '2025-12-01',
      'manufacturer': 'ABC Pharmaceuticals',
      'image': 'Paracetamol.jpeg',
    },
    {
      'name': 'Ibuprofen',
      'dosageForm': 'Tablet',
      'strength': '200mg',
      'quantityAvailable': 15,
      'expiryDate': '2024-06-15',
      'manufacturer': 'XYZ Pharmaceuticals',
      'image': 'Ibuprofen.jpeg',
    },
    // Add more medicines here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi!, User', style: Theme.of(context).textTheme.headlineLarge),
        backgroundColor: AppColors.primaryColor, // Use color from app_colors.dart
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search Medicines',
                prefixIcon: Icon(Icons.search),
                hintStyle: TextStyle(
                  fontFamily: AppFonts.primaryFont, // Use font from app_fonts.dart
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: medicines.length + 1, // One extra for the icon button
              itemBuilder: (context, index) {
                if (index == medicines.length) {
                  // This is the icon below the list
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Center(
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SellMedicinePage()));
                            },
                            child: Icon(Icons.add), // Plus icon
                            backgroundColor: AppColors.primaryColor, // Use color from app_colors.dart
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Need to add new medicines to your list?",
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont, // Use font from app_fonts.dart
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor, // Use color from app_colors.dart
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Simply tap the '+' button to quickly add and manage your medicine stock. Ensure that you regularly update expired medicines.",
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont, // Use font from app_fonts.dart
                            fontSize: 14,
                            color: AppColors.textColorSecondary, // Use color from app_colors.dart
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                final medicine = medicines[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/${medicine["image"]}',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicine['name']!,
                                style: TextStyle(
                                  fontFamily: AppFonts.primaryFont, // Use font from app_fonts.dart
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor, // Use color from app_colors.dart
                                ),
                              ),
                              Text(
                                'Manufacturer: ${medicine['manufacturer']}',
                                style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  fontSize: 14,
                                  color: AppColors.textColorSecondary, // Use color from app_colors.dart
                                ),
                              ),
                              Text(
                                'Expiry Date: ${medicine['expiryDate']}',
                                style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  fontSize: 14,
                                  color: AppColors.textColorSecondary, // Use color from app_colors.dart
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
