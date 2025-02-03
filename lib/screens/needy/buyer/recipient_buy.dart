import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfirmOrderPage_Buyer extends StatefulWidget {
  @override
  _ConfirmOrderPage_BuyerState createState() => _ConfirmOrderPage_BuyerState();
}

class _ConfirmOrderPage_BuyerState extends State<ConfirmOrderPage_Buyer> {
  String? prescriptionImage; // Store the image path
  String selectedPaymentMethod = 'Debit Card'; // Default payment method
  late Razorpay razorpay;

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        prescriptionImage = image.path; // Save the selected image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Order',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Please review your order details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Text about uploading prescription image
            Text(
              'Upload Image of Prescription:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),

            // Container to display the uploaded image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: prescriptionImage == null
                  ? Center(child: Text('No image selected'))
                  : Image.file(
                File(prescriptionImage!), // Display the selected image
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),

            // Button to select image
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Upload Image'),
            ),

            SizedBox(height: 20),

            // Confirm Order button
            ElevatedButton(
              onPressed: () {
                var options = {
                  'key': 'rzp_test_GcZZFDPP0jHtC4',
                  'amount': 1000, // Amount in paise (₹10)
                  'name': 'Medicine order',
                  'description': 'Easy Redistribution',
                  'prefill': {
                    'contact': '8888888888',
                    'email': 'test@razorpay.com'
                  }
                };
                razorpay.open(options);
              },
              child: Text('Proceed for Payment >>'),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment Successful!");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BuyerHomePage()), // Correct navigation
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed!");
  }

  @override
  void dispose() {
    try {
      razorpay.clear(); // Removes all listeners
    } catch (e) {
      print(e);
    }
    super.dispose();
  }
}

// Placeholder for Buyer Home Page
class BuyerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buyer Home Page')),
      body: Center(
        child: Text('Welcome to Buyer Home Page!'),
      ),
    );
  }
}
