import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/screens/giver/donor/donation_request.dart'; // Import the DonationRequestPage
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

class RequestForMedicinesPage extends StatefulWidget {
  @override
  _RequestForMedicinesPageState createState() =>
      _RequestForMedicinesPageState();
}

class _RequestForMedicinesPageState extends State<RequestForMedicinesPage> {
  final _formKey = GlobalKey<FormState>();
  String medicineName = '';
  String quantity = '';
  String strength = '';
  String urgency = '';

  // Reference to Firestore instance

  // Submit the request to Firestore
  Future<void> _submitRequest() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not logged in. Please log in to proceed.");
      }
      final requestDocRef = firestore.collection('users').doc(user.uid);
      final requestSnapshot = await requestDocRef.get();

      if (!requestSnapshot.exists) {
        throw Exception("User data not found in Firestore. Please log in again.");
      }
      // Create the request data
      final requestData = {
        'medicineName': medicineName,
        'quantity': quantity,
        'strength': strength,
        'urgency': urgency,
        'userEmail': user.email,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add request data to Firestore under the "Requested Medicines" collection
      await requestDocRef.collection('Requested Medicines').add(requestData); // Firestore will auto-generate the document ID

      // Show success message and navigate to the DonationRequestPage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted!')),
      );

      // Navigate to the DonationRequestPage and pass the submitted request data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DonationRequestPage(
            medicineName: medicineName,
            quantity: quantity,
            strength: strength,
            urgency: urgency,
          ),
        ),
      );

      // Clear the form fields after a delay of 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        _clearFormFields();
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Clear all form fields
  void _clearFormFields() {
    setState(() {
      medicineName = '';
      quantity = '';
      strength = '';
      urgency = '';
    });
  }

  // Retrieve requested medicines from Firestore
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request for Medicines',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Request Form Section
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Medicine Name',
                      labelStyle: AppFonts.body.copyWith(color: AppColors.textColor),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      medicineName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the medicine name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Quantity Needed',
                      labelStyle: AppFonts.body.copyWith(color: AppColors.textColor),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      quantity = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the quantity';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Strength (e.g., 500 mg)',
                      labelStyle: AppFonts.body.copyWith(color: AppColors.textColor),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      strength = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the strength';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Urgency',
                      labelStyle: AppFonts.body.copyWith(color: AppColors.textColor),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      urgency = value;
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitRequest(); // Submit the request to Firestore
                      }
                    },
                    child: Text(
                      'Submit Request',
                      style: AppFonts.button.copyWith(color: AppColors.whiteColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),

            // Display Requested Medicines (optional, not in use here)
          ],
        ),
      ),
    );
  }
}
