import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'instruction_card_model.dart';

class InstructionCardWidget extends StatelessWidget {
  final InstructionCard card;

  const InstructionCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Card(
          elevation: 6, // Increased elevation for a more elevated feel
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.lightGrey, width: 1.5), // Subtle border
          ),
          color: AppColors.backgroundColor, // Light background from theme
          margin: const EdgeInsets.symmetric(horizontal: 24),
          shadowColor: AppColors.textColor.withOpacity(0.2), // Light shadow for depth
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  card.title,
                  style: AppFonts.heading.copyWith(
                    color: AppColors.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Image.asset(
                  card.iconPath,
                  width: 150,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    card.description,
                    style: AppFonts.body.copyWith(
                      color: AppColors.textColorSecondary,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
