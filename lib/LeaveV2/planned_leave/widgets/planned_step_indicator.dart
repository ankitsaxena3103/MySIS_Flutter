/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../../common/widgets/common_text.dart';
import '../../../constants/app_colors.dart';

class PlannedStepIndicator extends StatelessWidget {
  /// 1 = Reason, 2 = Dates, 3 = Confirm
  final int currentStep;

  const PlannedStepIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Row(
        children: [
          _buildStep(1, 'Reason'),
          _buildLine(isActive: currentStep > 1),
          _buildStep(2, 'Dates'),
          _buildLine(isActive: currentStep > 2),
          _buildStep(3, 'Confirm'),
        ],
      ),
    );
  }

  Widget _buildStep(int step, String label) {
    final bool isCompleted = currentStep > step;
    final bool isActive = currentStep == step;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCompleted || isActive ? AppColors.green700 : AppColors.grey300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check_rounded, size: 16, color: AppColors.white)
                : CommonText(
                    '$step',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.white : AppColors.grey600,
                  ),
          ),
        ),
        const SizedBox(height: 6),
        SubLabelText(
          label,
          fontSize: 12,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: isActive ? AppColors.green700 : AppColors.grey500,
        ),
      ],
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 22, left: 6, right: 6),
        color: isActive ? AppColors.green700 : AppColors.grey300,
      ),
    );
  }
}
