import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meds/screens/needy/free_needy/needy_confirmation_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class NeedyHomePage extends StatefulWidget {
  @override
  _NeedyHomePageState createState() => _NeedyHomePageState();
}

class _NeedyHomePageState extends State<NeedyHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> medicinesList = [];

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    try {
      QuerySnapshot pharmacistsSnapshot =
          await _firestore.collection('Pharmacists').get();
      List<Map<String, dynamic>> tempList = [];

      for (var pharmacistDoc in pharmacistsSnapshot.docs) {
        String donorEmail = pharmacistDoc.data().toString().contains('email')
            ? pharmacistDoc.get('email')
            : 'No email';

        CollectionReference approvedMedicinesRef =
            pharmacistDoc.reference.collection('Approved Medicine');

        QuerySnapshot medicinesSnapshot = await approvedMedicinesRef.get();

        for (var medicineDoc in medicinesSnapshot.docs) {
          Map<String, dynamic> medicineData =
              medicineDoc.data() as Map<String, dynamic>;

          medicineData['donorEmail'] = donorEmail;
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
          'Donated Medicines',
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Medicine Image
                              Image.asset(
                                medicine['ImagePath'] ??
                                    'assets/images/placeholder.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 10),
                              // Medicine Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // The missing bracketing issue was here.
                                    // Corrected it by enclosing the column properly
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center, // Center vertically within the available space
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center, // Center horizontally
                                      children: [
                                        Text(
                                          medicine['MedicineName'] ??
                                              "Unknown Medicine",
                                          style: AppFonts.body.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.secondaryColor,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        _buildRichText(
                                          label: 'Manufacturer: ',
                                          value:
                                              medicine['Manufacturer'] ??
                                                  "Unknown",
                                        ),
                                        _buildRichText(
                                          label: 'Expiry Date: ',
                                          value: medicine['ExpirationDate'] ??
                                              "N/A",
                                        ),
                                        _buildRichText(
                                          label: 'Donor Email: ',
                                          value:
                                              medicine['donorEmail'] ?? "Unknown",
                                        ),
                                        SizedBox(height: 16), // Spacer before the button
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderConfirmationPage(),
                                              ),
                                            );
                                          },
                                          child: Text('Claim', style: AppFonts.button),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.buttonPrimaryColor,
                                            foregroundColor: AppColors.buttonTextColor,
                                          ),
                                        ),
                                      ],
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
