import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Firestore import
import 'package:meds/screens/ngo/admin/approval_confirmation_page.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

class ViewDonatedMedicinesPage extends StatefulWidget {
  @override
  State<ViewDonatedMedicinesPage> createState() => _ViewDonatedMedicinesPageState();
}

class _ViewDonatedMedicinesPageState extends State<ViewDonatedMedicinesPage> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Text controller for searching
  final TextEditingController _searchController = TextEditingController();

  // Lists to hold fetched medicines
  List<Map<String, dynamic>> _allMedicines = [];
  List<Map<String, dynamic>> _filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    // Fetch medicines once the widget is initialized
    fetchMedicines();
  }

  /// Fetches all user docs from "users" collection, then gets
  /// each user's "Donated Medicine" subcollection documents.
  Future<void> fetchMedicines() async {
    try {
      // 1. Get all documents from 'users' collection
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();

      List<Map<String, dynamic>> tempList = [];

      // 2. For each user document, get the "Donated Medicine" subcollection
      for (var userDoc in usersSnapshot.docs) {
        // Access the subcollection reference
        CollectionReference donatedMedicinesRef =
        userDoc.reference.collection('Donated Medicine');

        // 3. Get all documents from "Donated Medicine"
        QuerySnapshot medicinesSnapshot = await donatedMedicinesRef.get();

        // 4. For each donated medicine document, add it to our tempList
        for (var medicineDoc in medicinesSnapshot.docs) {
          Map<String, dynamic> medicineData =
          medicineDoc.data() as Map<String, dynamic>;

          // Optionally, you can also store user info or doc IDs
          // e.g., medicineData['userId'] = userDoc.id;
          // e.g., medicineData['medicineDocId'] = medicineDoc.id;

          tempList.add(medicineData);
        }
      }

      // Update state with the fetched medicines
      setState(() {
        _allMedicines = tempList;
        _filteredMedicines = tempList; // initially show all
      });
    } catch (e) {
      print('Error fetching medicines: $e');
      // Handle error (e.g., show a Snackbar or error message)
    }
  }

  /// Filters the medicines based on the search query.
  void _searchMedicines(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      _filteredMedicines = _allMedicines.where((medicine) {
        // Adjust field name to match your Firestore doc field (e.g. 'MedicineName')
        final name = (medicine['MedicineName'] ?? '').toLowerCase();
        return name.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donated Medicines',
          style: TextStyle(
            fontFamily: AppFonts.secondaryFont,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: AppColors.textColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          // -- Search bar at the top --
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search Medicines',
                hintStyle: TextStyle(
                  fontFamily: AppFonts.primaryFont,
                  fontSize: 16,
                  color: AppColors.textColorSecondary,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.iconColor),
              ),
              onChanged: (value) {
                // Filter medicines as user types
                _searchMedicines(value);
              },
            ),
          ),

          // -- List of fetched (and filtered) medicines --
          Expanded(
            child: _filteredMedicines.isEmpty
                ? Center(child: Text('Loading medicines...'))
                : ListView.builder(
              itemCount: _filteredMedicines.length,
              itemBuilder: (context, index) {
                final medicine = _filteredMedicines[index];

                // Adjust field names to match your Firestore fields
                final name = medicine['MedicineName'] ?? 'Unknown Medicine';
                final manufacturer = medicine['Manufacturer'] ?? 'Unknown Manufacturer';
                final expiryDate = medicine['ExpirationDate'] ?? 'No Expiry Date';
                final price = medicine['Price'] ?? 'N/A';
                final imagePath = medicine['ImagePath'] ?? 'default_image.jpg';

                return Card(
                  margin: EdgeInsets.all(10),
                  color: AppColors.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // If you're storing image paths in Firestore for local assets:
                        Image.asset(
                          'assets/images/$imagePath',
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback icon if the asset isn't found
                            return Icon(Icons.medical_services, size: 50);
                          },
                        ),
                        SizedBox(width: 10),

                        // -- Medicine Info --
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontFamily: AppFonts.secondaryFont,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.textColor,
                                ),
                              ),
                              Text(
                                'Manufacturer: $manufacturer',
                                style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  fontSize: 14,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              Text(
                                'Expiry Date: $expiryDate',
                                style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  fontSize: 14,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              Text(
                                'Price: $price',
                                style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  fontSize: 14,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              SizedBox(height: 10),

                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NGOActionConfirmationPage(isApproved: true),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonPrimaryColor,
                                ),
                                child: Text(
                                  'Approve',
                                  style: TextStyle(
                                    fontFamily: AppFonts.secondaryFont,
                                    fontSize: 16,
                                    color: AppColors.buttonTextColor,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NGOActionConfirmationPage(isApproved: false),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonSecondaryColor,
                                ),
                                child: Text(
                                  'Reject',
                                  style: TextStyle(
                                    fontFamily: AppFonts.secondaryFont,
                                    fontSize: 16,
                                    color: AppColors.buttonTextColor,
                                  ),
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
