import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/screens/giver/donor/DonationConfirmationPage.dart';

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

    if (pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _expirationDateController.text = "${pickedDate?.toLocal()}".split(' ')[0];
      });
    }
  }

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
        MaterialPageRoute(builder: (context) => DonationConfirmationPage()),
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
        title: Text(
          'Donate Medicines',
          style: TextStyle(
            fontFamily: AppFonts.secondaryFont,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: AppColors.whiteColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTextField(_medicineNameController, 'Medicine Name'),
              _buildTextField(_strengthController, 'Strength (e.g., 500 mg)'),
              _buildTextField(_quantityController, 'Quantity Available', keyboardType: TextInputType.number),
              _buildTextField(_expirationDateController, 'Expiration Date (YYYY-MM-DD)', readOnly: true, icon: Icons.calendar_today, onTap: _pickExpirationDate),
              _buildTextField(_manufacturerController, 'Manufacturer'),
              _buildTextField(_notesController, 'Additional Notes (optional)'),
              SizedBox(height: 20),
              _buildImagePicker(),
              SizedBox(height: 10),
              _buildButton('Upload Image', _pickImage, AppColors.secondaryColor),
              SizedBox(height: 30),
              _buildButton('Submit Donation', _submitDonation, AppColors.primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, bool readOnly = false, IconData? icon, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: AppFonts.primaryFont, color: AppColors.textColor),
          border: OutlineInputBorder(),
          suffixIcon: icon != null ? IconButton(icon: Icon(icon, color: AppColors.iconColor), onPressed: onTap) : null,
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Medicine_Image == null
          ? Center(child: Text('No image selected', style: TextStyle(color: AppColors.textColor)))
          : Image.file(File(Medicine_Image!), fit: BoxFit.cover),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
    );
  }
}
