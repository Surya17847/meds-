import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class SelledMed extends StatefulWidget {
  @override
  _SelledMedState createState() => _SelledMedState();
}

class _SelledMedState extends State<SelledMed> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> medicinesList = [];

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        var medicinesCollection = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('Selled Medicine')
            .get();

        List<Map<String, dynamic>> tempList = [];
        for (var medicineDoc in medicinesCollection.docs) {
          Map<String, dynamic> medicineData = medicineDoc.data();
          medicineData['sellerEmail'] = currentUser.email;
          tempList.add(medicineData);
        }

        setState(() {
          medicinesList = tempList;
        });
      }
    } catch (e) {
      print("Error fetching medicines: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sold Medicines', style: AppFonts.heading), // Use AppFonts.heading for title
        backgroundColor: AppColors.primaryColor, // Use AppColors.primaryColor for AppBar background
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white, // White background for the input field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryColor), // Primary color border
                ),
                hintText: 'Search Medicines...',
                hintStyle: TextStyle(color: AppColors.textColorSecondary), // Use light grey for hint text
                prefixIcon: Icon(Icons.search, color: AppColors.primaryColor), // Use primary color for icon
              ),
              onChanged: (value) {},
            ),
          ),
          Expanded(
            child: medicinesList.isEmpty
                ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor)) // Use primary color for loading spinner
                : ListView.builder(
                    itemCount: medicinesList.length,
                    itemBuilder: (context, index) {
                      final medicine = medicinesList[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.lightGrey, // Use light grey for the background
                                ),
                                child: medicine['ImagePath'] != null
                                    ? Image.asset(
                                        medicine['ImagePath'] ?? 'assets/images/placeholder.png',
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(Icons.medical_services, size: 30, color: AppColors.iconColor), // Use icon color from AppColors
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      medicine['medicine_name'] ?? "Unknown Medicine",
                                      style: AppFonts.heading.copyWith(
                                        color: AppColors.textColor, // Use primary text color
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    _buildInfoRow("Composition:", medicine['composition_mg'] ?? "Unknown"),
                                    _buildInfoRow("Expiry Date:", medicine['expiry_date'] ?? "N/A"),
                                    _buildInfoRow("Sold Price:", "₹${medicine['selled_price'] ?? "Unknown"}"),
                                    _buildInfoRow("Quantity:", medicine['quantity'] ?? "N/A"),
                                    _buildInfoRow("Sold Quantity:", medicine['remaining_quantity'] ?? "N/A"),
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

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: RichText(
        text: TextSpan(
          style: AppFonts.body, // Use AppFonts.body style for the information text
          children: [
            TextSpan(
              text: "$title ",
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor), // Primary text color for the title
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: AppColors.textColorSecondary), // Secondary text color for the value
            ),
          ],
        ),
      ),
    );
  }
}
