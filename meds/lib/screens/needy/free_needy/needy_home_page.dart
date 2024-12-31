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
      QuerySnapshot querySnapshot = await _firestore
          .collection('Donors_Users')
          .get();

      List<Map<String, dynamic>> tempList = [];

      // Loop through each donor to fetch medicines
      for (var donorDoc in querySnapshot.docs) {
        var medicinesCollection = await _firestore
            .collection('Donors_Users')
            .doc(donorDoc.id)
            .collection('Medicine')
            .get();

        for (var medicineDoc in medicinesCollection.docs) {
          Map<String, dynamic> medicineData = medicineDoc.data();
          medicineData['donorEmail'] = donorDoc.id; // Add donor email to medicine data
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
                          width: 50,
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Manufacturer: ${medicine['Manufacturer'] ?? "Unknown"}'),
                              Text('Expiry Date: ${medicine['ExpirationDate'] ?? "N/A"}'),
                              Text('Donor Email: ${medicine['donorEmail'] ?? "Unknown"}'),
                              Text('Quantity: ${medicine['Quantity'] ?? "N/A"}'),
                              Text('Strength: ${medicine['Strength'] ?? "N/A"}'),
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