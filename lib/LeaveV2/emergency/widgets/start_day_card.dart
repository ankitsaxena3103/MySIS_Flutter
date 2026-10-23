/*
 * Created by Ashu Rajput on 22-10-2026.
 */
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../common/widgets/common_text.dart'; // adjust path if needed

class StartDayCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const StartDayCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFEBEE) : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.red700 : AppColors.grey300,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected ? AppColors.red700 : AppColors.grey600,
              ),
              const SizedBox(height: 10),
              LabelText(
                title,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.red700 : AppColors.textPrimary,
              ),
              const SizedBox(height: 4),
              SubLabelText(
                subtitle,
                fontSize: 12,
                color: isSelected ? AppColors.red700 : AppColors.grey600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



