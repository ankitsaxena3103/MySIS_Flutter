/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../../common/widgets/common_text.dart';
import '../../../constants/app_colors.dart';

class PlannedReviewCard extends StatelessWidget {
  final String fromDate;
  final String toDate;
  final String reason;
  final int days;
  final int balanceDays;
  final VoidCallback? onEdit;

  const PlannedReviewCard({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.days,
    required this.balanceDays,
    this.onEdit,
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge + Edit
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: AppColors.green700,
                    ),
                    const SizedBox(width: 5),
                    SubLabelText(
                      'Planned Leave',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.green700,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: AppColors.grey600,
                    ),
                    const SizedBox(width: 4),
                    SubLabelText(
                      'Edit',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey700,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // From / To
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubLabelText(
                      'From',
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(height: 4),
                    LabelText(
                      fromDate,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubLabelText(
                      'To',
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(height: 4),
                    LabelText(
                      toDate,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Reason
          SubLabelText(
            'Reason',
            fontSize: 12,
            color: AppColors.grey500,
          ),
          const SizedBox(height: 4),
          LabelText(
            reason,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 16),
          Divider(color: AppColors.grey200, height: 1),
          const SizedBox(height: 14),

          // Days + Balance
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubLabelText(
                      'Days',
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(height: 4),
                    LabelText(
                      '$days days',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubLabelText(
                      'Balance',
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_right_alt_rounded,
                          size: 18,
                          color: AppColors.red900,
                        ),
                        const SizedBox(width: 4),
                        LabelText(
                          '$balanceDays days',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.red900,
                        ),
                      ],
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
