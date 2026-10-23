/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../../common/widgets/common_text.dart';
import '../../../constants/app_colors.dart';

class ApprovedDetailsCard extends StatelessWidget {
  final String fromDate;
  final String toDate;
  final String reason;
  final String backOnDuty;

  const ApprovedDetailsCard({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.backOnDuty,
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

          // Back on Duty
          SubLabelText(
            'Back on Duty',
            fontSize: 12,
            color: AppColors.grey500,
          ),
          const SizedBox(height: 4),
          LabelText(
            backOnDuty,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
