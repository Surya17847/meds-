import 'package:flutter/material.dart';
import 'package:meds/screens/needy/recipients_home_page.dart';

class BuyerConformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details',style: Theme.of(context).textTheme.headlineLarge,),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thank you for your purchase!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Here are the details of your purchase:',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 20),

            // Placeholder for order information
            Row(
              children: [
                Text('Medicine:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text('Paracetamol', style: TextStyle(fontSize: 18)), // Example medicine name
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Quantity:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text('2 boxes', style: TextStyle(fontSize: 18)), // Example quantity
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Total Price:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text('Rs.30', style: TextStyle(fontSize: 18)), // Example price
              ],
            ),
            SizedBox(height: 30),

            // Button to go back to Home Screen
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => RecipientsHomePage()), // Replace RecipientsHomePage with the actual class for that page
                        (Route<dynamic> route) => false, // This will clear all the previous routes
                  );         },
                child: Text('Go to Home'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}