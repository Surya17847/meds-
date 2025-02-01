import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonatedMed extends StatefulWidget {
  @override
  _DonatedMed_pageState createState() => _DonatedMed_pageState();
}

class _DonatedMed_pageState extends State<DonatedMed> {
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
        title: Text(
          'Donated Medicines',
            style: Theme.of(context).textTheme.headlineLarge),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search for a medicine...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Add search logic here (Optional)
              },
            ),
          ),
          Expanded(
            child: medicinesList.isEmpty
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: medicinesList.length,
              itemBuilder: (context, index) {
                final medicine = medicinesList[index];
                return Card(
                  elevation: 4,
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
                            color: Colors.grey[200],
                          ),
                          child: medicine['ImagePath'] != null
                              ? Image.asset(
                            medicine['ImagePath']??
                                'assets/images/placeholder.png',
                            fit: BoxFit.cover,
                          )
                              : Icon(Icons.medical_services, size: 30),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicine['MedicineName'] ?? "Unknown Medicine",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Manufacturer: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, // Bold title
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${medicine['Manufacturer'] ?? "Unknown"}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal, // Normal content
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Expiry Date: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, // Bold title
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${medicine['ExpirationDate'] ?? "N/A"}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal, // Normal content
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Donor Email: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, // Bold title
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${medicine['donorEmail'] ?? "Unknown"}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal, // Normal content
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Quantity: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, // Bold title
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${medicine['Quantity'] ?? "N/A"}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal, // Normal content
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Strength: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, // Bold title
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${medicine['Strength'] ?? "N/A"}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal, // Normal content
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
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
