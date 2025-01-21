import 'package:flutter/material.dart';
import 'package:meds/screens/needy/Buyer/buyer_conformation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          medicineData['Seller Email'] =
              userDoc.get('email'); // Add donor email
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
          "Available Medicines to Purchase",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
              onChanged: (value) {},
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
                      crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
                      children: [
                        // Medicine image
                        Image.asset(
                          medicine['ImagePath'] ??
                              'assets/images/placeholder.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        // Medicine details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${medicine['medicine_name'] ?? "Unknown Medicine"}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
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
                                value: medicine['Seller Email'] ??
                                    "Unknown",
                              ),
                              _buildRichText(
                                label: 'Price: ',
                                value: medicine['selled_price']
                                    ?.toString() ??
                                    "N/A",
                              ),
                            ],
                          ),
                        ),
                        // Claim button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BuyerConformationPage(),
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

  Widget _buildRichText({required String label, required dynamic value}) {
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
            text: value.toString(),
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
