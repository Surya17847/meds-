import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class DonatedMed extends StatefulWidget {
  @override
  _DonatedMedPageState createState() => _DonatedMedPageState();
}

class _DonatedMedPageState extends State<DonatedMed> {
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
            .collection('Donated Medicine')
            .get();

        List<Map<String, dynamic>> tempList = [];
        for (var medicineDoc in medicinesCollection.docs) {
          Map<String, dynamic> medicineData = medicineDoc.data();
          medicineData['donorEmail'] = currentUser.email;
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
        title: Text('Donated Medicines', style: AppFonts.heading),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for a medicine...',
                prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              onChanged: (value) {
                // Optional: Add search functionality
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: medicinesList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: medicinesList.length,
                      itemBuilder: (context, index) {
                        final medicine = medicinesList[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[200],
                                  ),
                                  child: medicine['ImagePath'] != null
                                      ? Image.asset(
                                          medicine['ImagePath'] ??
                                              'assets/images/placeholder.png',
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(Icons.medical_services, size: 30, color: AppColors.primaryColor),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        medicine['MedicineName'] ?? "Unknown Medicine",
                                        style: AppFonts.body.copyWith(color: AppColors.primaryColor),
                                      ),
                                      const SizedBox(height: 4),
                                      _infoText("Manufacturer", medicine['Manufacturer']),
                                      _infoText("Expiry Date", medicine['ExpirationDate']),
                                      _infoText("Donor Email", medicine['donorEmail']),
                                      _infoText("Quantity", medicine['Quantity']),
                                      _infoText("Strength", medicine['Strength']),
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
      ),
    );
  }

  Widget _infoText(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: RichText(
        text: TextSpan(
          style: AppFonts.body,
          children: [
            TextSpan(
              text: "$label: ",
              style: AppFonts.body,
            ),
            TextSpan(
              text: value?.toString() ?? "N/A",
              style: AppFonts.caption.copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}