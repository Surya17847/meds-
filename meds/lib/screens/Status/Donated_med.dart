import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class DonatedMed extends StatefulWidget {
  @override
  _DonatedMed_pageState createState() => _DonatedMed_pageState();
}

class _DonatedMed_pageState extends State<DonatedMed> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // FirebaseAuth instance to get current user
  List<Map<String, dynamic>> medicinesList = [];

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  // Fetch Medicines from Firestore (only for the current user)
  Future<void> fetchMedicines() async {
    try {
      User? currentUser = _auth.currentUser; // Get current user

      if (currentUser != null) {
        // Fetch medicines only for the current user
        var medicinesCollection = await _firestore
            .collection('users')
            .doc(currentUser.uid) // Use current user's UID to fetch their data
            .collection('Medicine')
            .get();

        List<Map<String, dynamic>> tempList = [];

        // Loop through medicines for the current user
        for (var medicineDoc in medicinesCollection.docs) {
          Map<String, dynamic> medicineData = medicineDoc.data();
          medicineData['donorEmail'] =
              currentUser.email; // Add current user's email as donor email
          tempList.add(medicineData);
        }

        setState(() {
          medicinesList = tempList;
        });
      } else {
        print('No user is logged in');
      }
    } catch (e) {
      print("Error fetching medicines: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donated Medicines',
            style: Theme.of(context).textTheme.headlineLarge),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search Medicines',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Add search logic here (Optional)
              },
            ),
          ),

          // Medicines List
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
                              // Medicine Image Placeholder
                              Image.asset(
                                medicine['ImagePath'] ??
                                    'assets/images/placeholder.png',
                                width: 30,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 10),

                              // Medicine Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${medicine['MedicineName'] ?? "Unknown Medicine"}',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Manufacturer: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight
                                                  .bold, // Bold for static text
                                              color: Colors
                                                  .black, // Add color if needed
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${medicine['Manufacturer'] ?? "Unknown"}',
                                            style: TextStyle(
                                              fontWeight: FontWeight
                                                  .normal, // Regular weight for dynamic data
                                              color: Colors
                                                  .black, // Add color if needed
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Expiry Date: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text:
                                                '${medicine['ExpirationDate'] ?? "N/A"}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Donor Email: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text:
                                                '${medicine['donorEmail'] ?? "Unknown"}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Quantity: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text:
                                                '${medicine['Quantity'] ?? "N/A"}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Strength: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text:
                                                '${medicine['Strength'] ?? "N/A"}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Claim Button
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
