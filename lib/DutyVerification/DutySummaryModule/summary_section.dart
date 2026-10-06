import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';

import 'summary_box.dart';

class SummarySection extends StatelessWidget {
  final int confirmed;
  final int claim;
  final int rejected;
  final int total;

  const SummarySection({
    super.key,
    required this.confirmed,
    required this.claim,
    required this.rejected,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 14),
      child: Row(
        children: [
          Expanded(
            child: SummaryBox(
              title: 'Duty Approved',
              count: '$confirmed/$total',
              color: AppColors.green700,
              background: AppColors.white,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SummaryBox(
              title: 'Claim',
              count: '$claim/$total',
              color: AppColors.white,
              background: AppColors.red700.withOpacity(0.75),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SummaryBox(
              title: 'Rejected',
              count: '$rejected/$total',
              color: AppColors.white,
              background: AppColors.red,
            ),
          ),
        ],
      ),
    );
  }
}
