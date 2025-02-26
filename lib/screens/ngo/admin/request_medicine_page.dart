import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/screens/giver/donor/donation_request.dart'; // Import the DonationRequestPage
import 'package:meds/utils/ui_helper/app_theme.dart';

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

  Future<void> _submitRequest() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User is not logged in. Please log in to proceed.");

      final requestDocRef = firestore.collection('users').doc(user.uid);
      final requestSnapshot = await requestDocRef.get();
      if (!requestSnapshot.exists) throw Exception("User data not found. Please log in again.");

      final requestData = {
        'medicineName': medicineName,
        'quantity': quantity,
        'strength': strength,
        'urgency': urgency,
        'userEmail': user.email,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await requestDocRef.collection('Requested Medicines').add(requestData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request submitted!')));
      
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

      Future.delayed(Duration(seconds: 2), () {
        _clearFormFields();
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _clearFormFields() {
    setState(() {
      medicineName = '';
      quantity = '';
      strength = '';
      urgency = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures keyboard doesn’t cause overflow
      appBar: AppBar(
        title: Text(
          'Request for Medicines',
          style: AppFonts.headline.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Fill the details below to request medicine',
              style: AppFonts.body.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 20),
            
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
                    onChanged: (value) => medicineName = value,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter the medicine name' : null,
                  ),
                  SizedBox(height: 20),
                  
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Quantity Needed',
                      labelStyle: AppFonts.body.copyWith(color: AppColors.textColor),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => quantity = value,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter the quantity' : null,
                  ),
                  SizedBox(height: 20),
                  
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Strength (e.g., 500 mg)',
                      labelStyle: AppFonts.body.copyWith(color: AppColors.textColor),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => strength = value,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter the strength' : null,
                  ),
                  SizedBox(height: 20),
                  
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Urgency',
                      labelStyle: AppFonts.body.copyWith(color: AppColors.textColor),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => urgency = value,
                  ),
                  SizedBox(height: 30),
                  
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitRequest();
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
          ],
        ),
      ),
    );
  }
}
