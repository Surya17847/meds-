import 'package:flutter/material.dart';
import 'package:meds/screens/ngo/admin/approval_confirmation_page.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

class ViewDonatedMedicinesPage extends StatefulWidget {
  @override
  State<ViewDonatedMedicinesPage> createState() => _ViewDonatedMedicinesPageState();
}

class _ViewDonatedMedicinesPageState extends State<ViewDonatedMedicinesPage> {
  final List<Map<String, dynamic>> medicines = [
    {
      'name': 'Paracetamol',
      'dosageForm': 'Tablet',
      'strength': '500mg',
      'quantityAvailable': 10,
      'expiryDate': '2025-12-01',
      'manufacturer': 'ABC Pharmaceuticals',
      'conditionTreated': 'Fever',
      'price':'Rs.40',
      'image': 'Paracetamol.jpeg',
    },
    {
      'name': 'Ibuprofen',
      'dosageForm': 'Tablet',
      'strength': '200mg',
      'quantityAvailable': 15,
      'expiryDate': '2024-06-15',
      'manufacturer': 'XYZ Pharmaceuticals',
      'conditionTreated': 'Pain Relief',
      'price':'Rs.30',
      'image': 'Ibuprofen.jpeg',
    },
    // Add more medicines here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donated Medicines',
          style: TextStyle(
            fontFamily: AppFonts.secondaryFont,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: AppColors.textColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search Medicines',
                hintStyle: TextStyle(fontFamily: AppFonts.primaryFont, fontSize: 16, color: AppColors.textColorSecondary),
                prefixIcon: Icon(Icons.search, color: AppColors.iconColor),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  color: AppColors.backgroundColor,
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
                                  fontFamily: AppFonts.secondaryFont,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.textColor,
                                ),
                              ),
                              Text(
                                'Manufacturer: ${medicine['manufacturer']}',
                                style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  fontSize: 14,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              Text(
                                'Expiry Date: ${medicine['expiryDate']}',
                                style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  fontSize: 14,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              Text(
                                'Price: ${medicine['price']}',
                                style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  fontSize: 14,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NGOActionConfirmationPage(isApproved: true),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonPrimaryColor,
                                ),
                                child: Text(
                                  'Approve',
                                  style: TextStyle(
                                    fontFamily: AppFonts.secondaryFont,
                                    fontSize: 16,
                                    color: AppColors.buttonTextColor,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NGOActionConfirmationPage(isApproved: false),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonSecondaryColor,
                                ),
                                child: Text(
                                  'Reject',
                                  style: TextStyle(
                                    fontFamily: AppFonts.secondaryFont,
                                    fontSize: 16,
                                    color: AppColors.buttonTextColor,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
