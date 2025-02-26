import 'package:flutter/material.dart';
import 'package:meds/screens/giver/Donor/donate_medicine.dart';
import 'package:meds/screens/ngo/admin/all_requested_medicine.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class DonorDashboard extends StatefulWidget {
  @override
  _DonorDashboardState createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<DonorDashboard> {
  List<Map<String, dynamic>> medicines = [
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
  ];

  List<Map<String, dynamic>> filteredMedicines = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMedicines = medicines;
    _searchController.addListener(() {
      filterMedicines();
    });
  }

  void filterMedicines() {
    setState(() {
      filteredMedicines = medicines
          .where((medicine) => medicine['name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate Medicines', style: AppFonts.headline.copyWith(color: AppColors.whiteColor)),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.list, color: AppColors.whiteColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllRequestedMedicinesPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                ),
                hintText: 'Search Medicines',
                hintStyle: AppFonts.caption,
                prefixIcon: Icon(Icons.search, color: AppColors.iconColor),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMedicines.length + 1,
              itemBuilder: (context, index) {
                if (index == filteredMedicines.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Center(
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DonateMedicinePage()),
                              );
                            },
                            backgroundColor: AppColors.primaryColor,
                            child: Icon(Icons.add, color: AppColors.whiteColor),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Need to add new medicines to your list?",
                          style: AppFonts.body.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Simply tap the '+' button to quickly add and manage your medicine stock. Ensure that you regularly update expired medicines.",
                            style: AppFonts.caption,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final medicine = filteredMedicines[index];
                return Card(
                  color: AppColors.whiteColor,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
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
                                style: AppFonts.body.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Manufacturer: ${medicine['manufacturer']}',
                                style: AppFonts.caption,
                              ),
                              Text(
                                'Expiry Date: ${medicine['expiryDate']}',
                                style: AppFonts.caption,
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
