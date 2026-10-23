/*
 * Created by Ashu Rajput on 22-10-2026.
 */
import 'package:flutter/material.dart';

import '../../common/widgets/common_text.dart';
import '../../constants/app_colors.dart';
import 'leave_status_badge.dart';

class LeaveHistoryItem extends StatelessWidget {
  final bool isEmergency; // true = red bell, false = green calendar
  final String dateRange;
  final String reason;
  final String duration;
  final LeaveStatus status;
  final VoidCallback? onTap;

  const LeaveHistoryItem({
    super.key,
    required this.isEmergency,
    required this.dateRange,
    required this.reason,
    required this.duration,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconBg = isEmergency ? AppColors.red900 : AppColors.green700;
    final IconData icon =
        isEmergency ? Icons.notifications_rounded : Icons.calendar_today_rounded;

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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.white, size: 20),
            ),
            const SizedBox(width: 12),

            // Date + reason
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText(
                    dateRange,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 3),
                  SubLabelText(
                    '$reason • $duration',
                    fontSize: 13,
                    color: AppColors.grey600,
                  ),
                ],
              ),
            ),

            LeaveStatusBadge(status: status),
          ],
        ),
      ),
    );
  }
}
