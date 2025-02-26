import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meds/screens/needy/Buyer/buyer_conformation_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class Buyer_Home_page extends StatefulWidget {
  @override
  _Buyer_Home_pageState createState() => _Buyer_Home_pageState();
}

class _Buyer_Home_pageState extends State<Buyer_Home_page> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> medicinesList = [];

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      List<Map<String, dynamic>> tempList = [];

      for (var userDoc in querySnapshot.docs) {
        CollectionReference selledMedicinesRef =
            userDoc.reference.collection('Selled Medicine');
        QuerySnapshot medicinesSnapshot = await selledMedicinesRef.get();

        for (var medicineDoc in medicinesSnapshot.docs) {
          Map<String, dynamic> medicineData =
              medicineDoc.data() as Map<String, dynamic>;
          medicineData['Seller Email'] = userDoc.get('email');
          tempList.add(medicineData);
        }
      }

      setState(() {
        medicinesList = tempList;
      });
    } catch (e) {
      print("Error fetching medicines: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Get your Medicines",
          style: AppFonts.headline.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: AppFonts.body,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search Medicines',
                hintStyle: AppFonts.caption,
                prefixIcon: Icon(Icons.search, color: AppColors.iconColor),
              ),
              onChanged: (value) {
                // You can add search filtering functionality here
              },
            ),
          ),
          Expanded(
            child: medicinesList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: medicinesList.length,
                    itemBuilder: (context, index) {
                      final medicine = medicinesList[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Medicine Image (Network Support)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    8), // Rounded corners for image
                                child: medicine['ImagePath'] != null &&
                                        medicine['ImagePath'].startsWith('http')
                                    ? Image.network(
                                        medicine['ImagePath'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          'assets/images/placeholder.png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/images/placeholder.png',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(width: 10),

                              // Medicine Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      medicine['medicine_name'] ??
                                          "Unknown Medicine",
                                      style: AppFonts.body.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    _buildRichText(
                                      label: 'Available Quantity: ',
                                      value: medicine['remaining_quantity']
                                              ?.toString() ??
                                          "Unknown",
                                    ),
                                    _buildRichText(
                                      label: 'Expiry Date: ',
                                      value: medicine['expiry_date'] ?? "N/A",
                                    ),
                                    _buildRichText(
                                      label: 'Seller Email: ',
                                      value: medicine['seller_email'] ??
                                          "Unknown", // Fixed Key
                                    ),
                                    _buildRichText(
                                      label: 'Price: ',
                                      value:
                                          'Rs. ${medicine['selling_price']?.toString() ?? "N/A"}', // Fixed Key
                                    ),
                                  ],
                                ),
                              ),

                              // Claim Button (Aligned Right)
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BuyerConformationPage(),
                                      ),
                                    );
                                  },
                                  child: Text('Claim', style: AppFonts.button),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.buttonPrimaryColor,
                                    foregroundColor: AppColors.buttonTextColor,
                                    minimumSize: Size(
                                        80, 40), // Ensures good button size
                                  ),
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

  Widget _buildRichText({required String label, required dynamic value}) {
    return RichText(
      text: TextSpan(
        style: AppFonts.body.copyWith(color: AppColors.textColor),
        children: [
          TextSpan(
            text: label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value.toString(),
          ),
        ],
      ),
    );
  }
}
