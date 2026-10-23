/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../../common/widgets/common_text.dart';
import '../../../constants/app_colors.dart';

class RejectedDetailsCard extends StatelessWidget {
  final String officerMessage;
  final String dateRange;
  final String leaveSummary; // e.g. "Emergency • Family Emergency • 2 days"

  const RejectedDetailsCard({
    super.key,
    required this.officerMessage,
    required this.dateRange,
    required this.leaveSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Area Officer says
          SubLabelText(
            'Area Officer says',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.grey600,
          ),
          const SizedBox(height: 8),
          LabelText(
            '"$officerMessage"',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),

          const SizedBox(height: 16),
          Divider(color: AppColors.grey200, height: 1),
          const SizedBox(height: 14),

          // Requested
          SubLabelText(
            'Requested',
            fontSize: 12,
            color: AppColors.grey500,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      dateRange,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 2),
                    SubLabelText(
                      leaveSummary,
                      fontSize: 13,
                      color: AppColors.grey600,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
