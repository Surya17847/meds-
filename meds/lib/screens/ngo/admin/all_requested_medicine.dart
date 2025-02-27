import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

class AllRequestedMedicinesPage extends StatefulWidget {
  @override
  _AllRequestedMedicinesPageState createState() => _AllRequestedMedicinesPageState();
}

class _AllRequestedMedicinesPageState extends State<AllRequestedMedicinesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Text controller for searching
  final TextEditingController _searchController = TextEditingController();

  // Lists to hold fetched medicines
  List<Map<String, dynamic>> _allRequestedMedicines = [];
  List<Map<String, dynamic>> _filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    // Fetch medicines once the widget is initialized
    fetchRequestedMedicines();
  }

  /// Fetches all requested medicines from Firestore
  Future<void> fetchRequestedMedicines() async {
    try {
      // Get all documents from "users" collection
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();

      List<Map<String, dynamic>> tempList = [];

      // Loop through each user document
      for (var userDoc in usersSnapshot.docs) {
        // Fetch requester's email from the user document
        final userData = userDoc.data() as Map<String, dynamic>;
        final String requesterEmail = userData['email'] ?? 'Unknown Email';
        final String requesterName= userData['name']??'Unknown Name';

        // Access the subcollection reference for "Requested Medicines" under each user
        CollectionReference requestedMedicinesRef = userDoc.reference.collection('Requested Medicines');

        // Get all medicines from the user's "Requested Medicines" subcollection
        QuerySnapshot medicinesSnapshot = await requestedMedicinesRef.get();

        // Loop through each medicine document in the subcollection
        for (var medicineDoc in medicinesSnapshot.docs) {
          Map<String, dynamic> medicineData = medicineDoc.data() as Map<String, dynamic>;

          // Handle missing or null fields to prevent issues
          final String medicineName = medicineData['medicineName'] ?? 'Unknown Medicine';
          final String quantity = medicineData['quantity'] ?? 'Unknown Quantity';
          final String strength = medicineData['strength'] ?? 'Unknown Strength';
          final String urgency = medicineData['urgency'] ?? 'No Urgency';
          final Timestamp? timestamp = medicineData['timestamp'];

          // Convert timestamp to a string if it exists
          final String formattedTimestamp = timestamp != null ? timestamp.toDate().toString() : 'No Timestamp';

          // Add the medicine data to the temporary list, including the requester's email
          tempList.add({
            'medicineName': medicineName,
            'quantity': quantity,
            'strength': strength,
            'urgency': urgency,
            'timestamp': formattedTimestamp,
            'name':requesterName,
            'requester': requesterEmail,

          });
        }
      }

      // Update the UI with the fetched data
      setState(() {
        _allRequestedMedicines = tempList;
        _filteredMedicines = tempList; // Initially show all medicines
      });
    } catch (e) {
      print('Error fetching requested medicines: $e');
      // Handle error (e.g., show a Snackbar or error message)
    }
  }

  /// Filters the medicines based on the search query.
  void _searchMedicines(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      _filteredMedicines = _allRequestedMedicines.where((medicine) {
        final name = (medicine['medicineName'] ?? '').toLowerCase();
        return name.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Requested Medicines',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          // Search bar
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

          // List of fetched and filtered medicines
          Expanded(
            child: _filteredMedicines.isEmpty
                ? Center(child: Text('Loading requested medicines...'))
                : ListView.builder(
              itemCount: _filteredMedicines.length,
              itemBuilder: (context, index) {
                final medicine = _filteredMedicines[index];

                final name = medicine['medicineName'] ?? 'Unknown Medicine';
                final quantity = medicine['quantity'] ?? 'Unknown Quantity';
                final strength = medicine['strength'] ?? 'Unknown Strength';
                final urgency = medicine['urgency'] ?? 'No Urgency';
                final timestamp = medicine['timestamp'] ?? 'No Timestamp';
                final r_name = medicine['name'] ?? 'Unknown Name';
                final requester = medicine['requester'] ?? 'Unknown Requester';

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: AppColors.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: AppFonts.secondaryFont,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Quantity: $quantity',
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 14,
                            color: AppColors.textColorSecondary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Strength: $strength',
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 14,
                            color: AppColors.textColorSecondary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Urgency: $urgency',
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 14,
                            color: AppColors.textColorSecondary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Requested on: $timestamp',
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 12,
                            color: AppColors.textColorSecondary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Requester Name: $r_name',
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 12,
                            color: AppColors.textColorSecondary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Requester Email: $requester',
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 12,
                            color: AppColors.textColorSecondary,
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
