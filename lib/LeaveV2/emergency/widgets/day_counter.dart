/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../../common/widgets/common_text.dart';
import '../../../constants/app_colors.dart';

class DayCounter extends StatelessWidget {
  final int days;
  final int maxDays;
  final ValueChanged<int> onChanged;

  const DayCounter({
    super.key,
    required this.days,
    this.maxDays = 6,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // −  number  +
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _circleButton(
              icon: Icons.remove,
              enabled: days > 1,
              onTap: () {
                if (days > 1) onChanged(days - 1);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  LabelText(
                    '$days',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red700,
                  ),
                  SubLabelText(
                    'days',
                    fontSize: 13,
                    color: AppColors.grey600,
                  ),
                ],
              ),
            ),
            _circleButton(
              icon: Icons.add,
              enabled: days < maxDays,
              onTap: () {
                if (days < maxDays) onChanged(days + 1);
              },
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Visual day pills
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxDays, (index) {
            final isUsed = index < days;
            return Container(
              width: 42,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isUsed ? AppColors.red700 : AppColors.grey200,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: isUsed
                  ? const CommonText(
                      'Use',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    )
                  : const SizedBox.shrink(),
            );
          }),
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? AppColors.grey400 : AppColors.grey300,
          ),
          color: AppColors.white,
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.grey700 : AppColors.grey400,
        ),
      ),
    );
  }
}
