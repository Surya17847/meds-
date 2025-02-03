import 'package:flutter/material.dart';
import 'package:meds/screens/needy/recipients_home_page.dart';

class OrderConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmed',style: Theme.of(context).textTheme.headlineLarge,),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Your order has been confirmed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for placing your order. We will notify you once the medicine is ready for delivery or pickup.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // Button to go back to Home Screen
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => RecipientsHomePage()), // Replace RecipientsHomePage with the actual class for that page
                      (Route<dynamic> route) => false, // This will clear all the previous routes
                );                },
              child: Text('Go to Home'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),

            // Button to View Order Details
            // ElevatedButton(
            //   onPressed: () {
            //     // Add logic to navigate to the order details screen if available
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text('Order details will be available soon.')),
            //     );
            //   },
            //   child: Text('View Order Details'),
            //   style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            //     textStyle: TextStyle(fontSize: 18),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}