import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';

import '../models/attendance_day.dart';
import '../models/attendance_status.dart';

class StatusBadge extends StatelessWidget {
  final AttendanceDay day;

  const StatusBadge({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    String text;
    Color fg;

    switch (day.status) {
      case AttendanceStatus.approved:
        text = 'Approved';
        fg = AppColors.green700;
        break;
      case AttendanceStatus.rejected:
        text = 'Rejected';
        fg = AppColors.red;
        break;
      default:
        text = day.claimPending ? 'Claim' : 'Pending';
        fg = day.claimPending ? AppColors.red700 : AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: fg),
      ),
    );
  }
}
