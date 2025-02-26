import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/screens/giver/donor/donation_confirmation_page.dart';

class DonateMedicinePage extends StatefulWidget {
  @override
  State<DonateMedicinePage> createState() => _DonateMedicinePageState();
}

class _DonateMedicinePageState extends State<DonateMedicinePage> {
  String? Medicine_Image;
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _strengthController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Image Picker
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        Medicine_Image = image.path;
      });
    }
  }

  DateTime? _selectedDate;

  Future<void> _pickExpirationDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _expirationDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  // Submit donation to Firestore
  Future<void> _submitDonation() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not logged in. Please log in to proceed.");
      }

      final donorDocRef = firestore.collection('users').doc(user.uid);
      final donorSnapshot = await donorDocRef.get();

      if (!donorSnapshot.exists) {
        throw Exception("User data not found in Firestore. Please log in again.");
      }

      final medicineData = {
        'MedicineName': _medicineNameController.text,
        'Strength': _strengthController.text,
        'Quantity': _quantityController.text,
        'ExpirationDate': _expirationDateController.text,
        'Manufacturer': _manufacturerController.text,
        'Notes': _notesController.text,
        'ImagePath': Medicine_Image ?? '',
        'DonationDate': DateTime.now().toIso8601String(),
      };

      await donorDocRef.collection('Donated Medicine').add(medicineData);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DonationConfirmationPage(medicine: medicineData),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate Medicines', style: AppFonts.heading),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTextField(_medicineNameController, 'Medicine Name'),
              SizedBox(height: 20),
              _buildTextField(_strengthController, 'Strength (e.g., 500 mg)'),
              SizedBox(height: 20),
              _buildTextField(_quantityController, 'Quantity Available', isNumber: true),
              SizedBox(height: 20),
              _buildDateField(),
              SizedBox(height: 20),
              _buildTextField(_manufacturerController, 'Manufacturer'),
              SizedBox(height: 20),
              _buildTextField(_notesController, 'Additional Notes (optional)'),
              SizedBox(height: 20),
              _buildImagePicker(),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitDonation,
                child: Text('Submit Donation', style: AppFonts.button),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppFonts.body,
        border: OutlineInputBorder(),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: _expirationDateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Expiration Date (YYYY-MM-DD)',
        labelStyle: AppFonts.body,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today, color: AppColors.iconColor),
          onPressed: _pickExpirationDate,
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Medicine_Image == null
              ? Center(child: Text('No image selected', style: AppFonts.caption))
              : Image.file(File(Medicine_Image!), fit: BoxFit.cover),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Upload Image', style: AppFonts.button),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonPrimaryColor),
        ),
      ],
    );
  }
}