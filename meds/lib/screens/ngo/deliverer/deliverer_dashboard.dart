import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

class DelivererDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deliverer Dashboard',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome to the Deliverer Dashboard',
              style: AppFonts.heading.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 20),
            Text(
              'Select an action below:',
              style: AppFonts.body.copyWith(color: AppColors.textColorSecondary),
            ),
            SizedBox(height: 20),

            // Pending Deliveries Section
            _buildDeliveryCard(
              context,
              title: 'Pending Deliveries',
              description: 'View and manage deliveries that are yet to be completed.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PendingDeliveriesPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Completed Deliveries Section
            _buildDeliveryCard(
              context,
              title: 'Completed Deliveries',
              description: 'View deliveries that have been successfully completed.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompletedDeliveriesPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Track Delivery Section
            _buildDeliveryCard(
              context,
              title: 'Track Delivery',
              description: 'Track the status and progress of a specific delivery.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrackDeliveryPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryCard(
      BuildContext context, {
        required String title,
        required String description,
        required VoidCallback onPressed,
      }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: AppFonts.heading.copyWith(color: AppColors.textColor),
        ),
        subtitle: Text(
          description,
          style: AppFonts.body.copyWith(color: AppColors.textColorSecondary),
        ),
        trailing: Icon(Icons.arrow_forward, color: AppColors.secondaryColor),
        onTap: onPressed,
      ),
    );
  }
}

// Placeholder Page for Pending Deliveries
class PendingDeliveriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Deliveries',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Text(
          'List of pending deliveries will be displayed here.',
          style: AppFonts.body.copyWith(color: AppColors.textColor),
        ),
      ),
    );
  }
}

// Placeholder Page for Completed Deliveries
class CompletedDeliveriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Completed Deliveries',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Text(
          'List of completed deliveries will be displayed here.',
          style: AppFonts.body.copyWith(color: AppColors.textColor),
        ),
      ),
    );
  }
}

// Placeholder Page for Tracking Delivery
class TrackDeliveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Track Delivery',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Track the progress of a specific delivery here.',
              style: AppFonts.body.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder action for tracking the delivery
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Tracking feature coming soon.")),
                );
              },
              child: Text('Track Delivery Now'),
            ),
          ],
        ),
      ),
    );
  }
}
