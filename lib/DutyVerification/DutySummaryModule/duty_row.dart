import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';

import '../models/attendance_day.dart';
import 'status_badge.dart';

class DutyRow extends StatelessWidget {
  final AttendanceDay day;

  const DutyRow({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.7),
        ),
      ),
      child: Row(
        children: [
          // DATE
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.dateLabel,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  day.dayName,
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // DUTY COUNT
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.totalDutyCount.toStringAsFixed(1),
                  style:
                      TextStyle(fontSize: 14, color: AppColors.textPrimary),
                ),
                if (day.shiftLabels.isNotEmpty)
                  Text(
                    day.shiftLabels.join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),

          // STATUS
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: StatusBadge(day: day),
            ),
          ),
        ],
      ),
    );
  }
}
