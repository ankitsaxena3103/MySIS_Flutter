/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../../common/widgets/common_text.dart';
import '../../../constants/app_colors.dart';

class TimelineStep {
  final String title;
  final String subtitle;
  final TimelineStepState state;

  const TimelineStep({
    required this.title,
    required this.subtitle,
    required this.state,
  });
}

enum TimelineStepState { completed, current, upcoming }

class StatusTimeline extends StatelessWidget {
  final List<TimelineStep> steps;

  const StatusTimeline({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicator + line
              Column(
                children: [
                  _buildIndicator(step.state),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: step.state == TimelineStepState.completed
                            ? AppColors.green600
                            : AppColors.grey300,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelText(
                        step.title,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: step.state == TimelineStepState.upcoming
                            ? AppColors.grey500
                            : AppColors.textPrimary,
                      ),
                      const SizedBox(height: 3),
                      SubLabelText(
                        step.subtitle,
                        fontSize: 12,
                        color: AppColors.grey600,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildIndicator(TimelineStepState state) {
    switch (state) {
      case TimelineStepState.completed:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.green600,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, size: 14, color: AppColors.white),
        );
      case TimelineStepState.current:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFFA000), width: 1.5),
          ),
          child: const Icon(
            Icons.access_time_rounded,
            size: 14,
            color: Color(0xFFE65100),
          ),
        );
      case TimelineStepState.upcoming:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.grey300, width: 1.5),
          ),
        );
    }
  }
}
