/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';
import '../../common/widgets/common_text.dart';
import '../../constants/app_colors.dart';

enum LeaveStatus { pending, approved, rejected }

class LeaveStatusBadge extends StatelessWidget {
  final LeaveStatus status;

  const LeaveStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bgColor;
    late Color textColor;
    late IconData icon;
    late String label;

    switch (status) {
      case LeaveStatus.pending:
        bgColor = const Color(0xFFFFF3E0); // soft orange/yellow
        textColor = const Color(0xFFE65100);
        icon = Icons.access_time_rounded;
        label = 'Pending';
        break;
      case LeaveStatus.approved:
        bgColor = const Color(0xFFE8F5E9); // soft green
        textColor = AppColors.green700;
        icon = Icons.check_rounded;
        label = 'Approved';
        break;
      case LeaveStatus.rejected:
        bgColor = const Color(0xFFFFEBEE); // soft red
        textColor = AppColors.red900;
        icon = Icons.close_rounded;
        label = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          SubLabelText(
            label,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ],
      ),
    );
  }
}


