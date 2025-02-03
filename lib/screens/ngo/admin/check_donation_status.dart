import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

class CheckDonationStatusPage extends StatelessWidget {
  final List<DonationStatus> donationStatuses = [
    DonationStatus(
      medicineName: 'Paracetamol',
      status: 'Delivered',
      date: '2023-09-20',
    ),
    DonationStatus(
      medicineName: 'Ibuprofen',
      status: 'Pending',
      date: '2023-09-22',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check Donation Status',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: donationStatuses.length,
        itemBuilder: (context, index) {
          return DonationStatusCard(
            medicineName: donationStatuses[index].medicineName,
            status: donationStatuses[index].status,
            date: donationStatuses[index].date,
          );
        },
      ),
    );
  }
}

class DonationStatusCard extends StatelessWidget {
  final String medicineName;
  final String status;
  final String date;

  DonationStatusCard({
    required this.medicineName,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicineName,
              style: AppFonts.body.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 8),
            Text(
              'Status: $status',
              style: AppFonts.body.copyWith(
                color: status == 'Delivered'
                    ? AppColors.successColor
                    : AppColors.warningColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Date: $date',
              style: AppFonts.body.copyWith(color: AppColors.textColor),
            ),
          ],
        ),
      ),
    );
  }
}

class DonationStatus {
  final String medicineName;
  final String status;
  final String date;

  DonationStatus({required this.medicineName, required this.status, required this.date});
}
