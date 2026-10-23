/*
 * Created by Ashu Rajput on 22-10-2026.
 */
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../common/widgets/common_text.dart'; // adjust path if needed

class NotificationItem extends StatelessWidget {
  final Color iconBgColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.iconBgColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.white, size: 20),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText(
                    title,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 3),
                  SubLabelText(
                    subtitle,
                    fontSize: 13,
                    color: AppColors.grey600,
                  ),
                  const SizedBox(height: 4),
                  SubLabelText(
                    time,
                    fontSize: 12,
                    color: AppColors.grey500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



