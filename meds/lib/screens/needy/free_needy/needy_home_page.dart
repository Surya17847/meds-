import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meds/screens/needy/free_needy/recipients_need.dart';

class Needy_Home_page extends StatefulWidget {
  @override
  _Needy_Home_pageState createState() => _Needy_Home_pageState();
}

class _Needy_Home_pageState extends State<Needy_Home_page> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> medicinesList = [];

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  // Fetch Medicines from Firestore
  Future<void> fetchMedicines() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      List<Map<String, dynamic>> tempList = [];

      // Loop through each donor to fetch medicines
      for (var userDoc in querySnapshot.docs) {
        var medicinesCollection = await _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('Medicine')
            .get();

        for (var medicineDoc in medicinesCollection.docs) {
          Map<String, dynamic> medicineData = medicineDoc.data();
          medicineData['donorEmail'] = userDoc.get('email'); // Add donor email
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
        title: Text('Donated Medicines', style: Theme.of(context).textTheme.headlineLarge),
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
                          medicine['ImagePath'] ?? 'assets/images/placeholder.png',
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
                                  color: Colors.green
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Manufacturer: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, // Bold for static text
                                        color: Colors.black, // Add color if needed
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${medicine['Manufacturer'] ?? "Unknown"}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal, // Regular weight for dynamic data
                                        color: Colors.black, // Add color if needed
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
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '${medicine['ExpirationDate'] ?? "N/A"}',
                                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Donor Email: ',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '${medicine['donorEmail'] ?? "Unknown"}',
                                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Quantity: ',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '${medicine['Quantity'] ?? "N/A"}',
                                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Strength: ',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '${medicine['Strength'] ?? "N/A"}',
                                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),

                        // Claim Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConfirmOrderPage_Needy(),
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
}
