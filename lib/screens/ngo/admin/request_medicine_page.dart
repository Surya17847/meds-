import 'package:flutter/material.dart';
import 'package:meds/screens/ngo/admin/admin_dashboard_page.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

class RequestForMedicinesPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  labelStyle: AppFonts.body.copyWith(color: AppColors.textColor),
                  border: OutlineInputBorder(),
                ),
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
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Request submitted!')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestConfirmationPage(),
                      ),
                    );
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
      ),
    );
  }
}

class RequestConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Submitted',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 100,
                color: AppColors.successColor,
              ),
              SizedBox(height: 20),
              Text(
                'Your medicine request has been successfully submitted!',
                textAlign: TextAlign.center,
                style: AppFonts.body.copyWith(color: AppColors.textColor),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AdminDashboardPage()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Text(
                  'Go Back',
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
      ),
    );
  }
}
