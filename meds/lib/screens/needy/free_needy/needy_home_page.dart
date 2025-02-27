import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meds/screens/needy/free_needy/needy_confirmation_page.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

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
      // Get all pharmacist documents.
      QuerySnapshot pharmacistsSnapshot =
      await _firestore.collection('Pharmacists').get();
      List<Map<String, dynamic>> tempList = [];

      // For each pharmacist, get medicines in their "Approved Medicine" subcollection.
      for (var pharmacistDoc in pharmacistsSnapshot.docs) {
        // Use a try/catch or check if the email field exists.
        String donorEmail = pharmacistDoc.data().toString().contains('email')
            ? pharmacistDoc.get('email')
            : 'No email';

        CollectionReference approvedMedicinesRef =
        pharmacistDoc.reference.collection('Approved Medicine');

        QuerySnapshot medicinesSnapshot =
        await approvedMedicinesRef.get();

        for (var medicineDoc in medicinesSnapshot.docs) {
          Map<String, dynamic> medicineData =
          medicineDoc.data() as Map<String, dynamic>;

          // Add the pharmacist's email as donorEmail to the medicine data.
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
          style: AppFonts.headlineLarge,
        ),
        backgroundColor: AppColors.primary,
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
              ),
              onChanged: (value) {
                // Add search logic if needed
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          medicine['ImagePath'] ?? 'assets/images/Paracetamol.jpeg',
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${medicine['MedicineName'] ?? "Unknown Medicine"}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              _buildRichText(
                                label: 'Manufacturer: ',
                                value: medicine['Manufacturer'] ?? "Unknown",
                              ),
                              _buildRichText(
                                label: 'Expiry Date: ',
                                value: medicine['ExpirationDate'] ?? "N/A",
                              ),
                              _buildRichText(
                                label: 'Donor Email: ',
                                value: medicine['donorEmail'] ?? "Unknown",
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderConfirmationPage(),
                              ),
                            );
                          },
                          child: Text('Claim'),
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

  Widget _buildRichText({required String label, required String value}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
