/*
 * Created by Ashu Rajput on 22-10-2026.
 */
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../common/widgets/common_text.dart'; // adjust if needed

class EmergencyReasonTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const EmergencyReasonTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppColors.red900,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.white, size: 22),
            ),
            const SizedBox(width: 14),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText(
                    title,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 3),
                  SubLabelText(
                    subtitle,
                    fontSize: 13,
                    color: AppColors.grey600,
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}



