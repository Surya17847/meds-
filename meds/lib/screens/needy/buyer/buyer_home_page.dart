
import 'package:flutter/material.dart';
import 'package:meds/screens/needy/Buyer/buyer_conformation_page.dart';
import 'package:meds/screens/needy/Buyer/buyer_home_page.dart';
class Buyer_Home_page extends StatelessWidget {
  final List<Map<String, dynamic>> medicines = [
    {
      'name': 'Paracetamol',
      'dosageForm': 'Tablet',
      'strength': '500mg',
      'quantityAvailable': 10,
      'expirationDate': '2025-12-01',
      'manufacturer': 'ABC Pharmaceuticals',
      'conditionTreated': 'Fever',
      'price':'Rs.30',
      'image': 'Paracetamol.jpeg',
    },
    {
      'name': 'Ibuprofen',
      'dosageForm': 'Tablet',
      'strength': '200mg',
      'quantityAvailable': 15,
      'expirationDate': '2024-06-15',
      'manufacturer': 'XYZ Pharmaceuticals',
      'conditionTreated': 'Pain Relief',
      'price':'Rs.40',
      'image': 'Ibuprofen.jpeg',
    },
    // Add more medicines here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Medicines to Purchase',style: Theme.of(context).textTheme.headlineLarge,),
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
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/${medicine["image"]}',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(width:10 ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicine['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Manufacturer: ${medicine['manufacturer']}'),
                              Text('Expiry Date: ${medicine['expiryDate']}'),
                              Text('Price: ${medicine['price']}'),

                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>BuyerConformationPage()));
                                },
                                child: Text('Buy'),
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