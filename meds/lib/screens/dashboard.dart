import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MedicineDashboard extends StatelessWidget {
  final int medicinesSold;
  final int medicinesDonated;
  final List<String> topRequestedMedicines;
  final double totalRevenue;

  const MedicineDashboard({
    Key? key,
    required this.medicinesSold,
    required this.medicinesDonated,
    required this.topRequestedMedicines,
    required this.totalRevenue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row displaying the "Medicines Sold" and "Medicines Donated" info cards.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard(
                  context,
                  icon: LucideIcons.pill,
                  title: 'Medicines Sold',
                  value: medicinesSold.toString(),
                  color: Colors.blue,
                ),
                const SizedBox(width: 16.0),
                _buildInfoCard(
                  context,
                  icon: LucideIcons.heart,
                  title: 'Medicines Donated',
                  value: medicinesDonated.toString(),
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Top Requested Medicines section.
            _buildTopRequestedMedicines(),
            const SizedBox(height: 16.0),
            // Full-width info card for Total Revenue.
            _buildInfoCard(
              context,
              icon: LucideIcons.dollarSign,
              title: 'Total Revenue',
              value: '\$${totalRevenue.toStringAsFixed(2)}',
              color: Colors.orange,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an info card with an icon, title, and value.
  /// The card now has a light (white) background with dark contents for readability.
  Widget _buildInfoCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        required Color color,
        bool fullWidth = false,
      }) {
    final Widget card = Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.white, // Light background
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32.0, color: Colors.black87), // Dark icon color
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Dark text color
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Dark text color
              ),
            ),
          ],
        ),
      ),
    );

    return fullWidth ? card : Expanded(child: card);
  }

  /// Builds the section that displays the top requested medicines.
  Widget _buildTopRequestedMedicines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Requested Medicines',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Column(
          children: topRequestedMedicines
              .map((medicine) => _buildMedicineTile(medicine))
              .toList(),
        ),
      ],
    );
  }

  /// Builds an individual medicine tile.
  Widget _buildMedicineTile(String medicine) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: const Icon(LucideIcons.pill, color: Colors.blueAccent),
        title: Text(
          medicine,
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}