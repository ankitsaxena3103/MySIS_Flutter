/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';
import 'package:mysis/LeaveV2/planned_leave/planned_leave_dates_screen.dart';

import '../../common/widgets/common_text.dart';
import '../../constants/app_colors.dart';
import 'widgets/planned_reason_tile.dart';
import 'widgets/planned_step_indicator.dart';

class PlannedLeaveReasonScreen extends StatelessWidget {
  const PlannedLeaveReasonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.black,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const LabelText(
          'Planned Leave',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step indicator
          const PlannedStepIndicator(currentStep: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabelText(
                    'What happened?',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 6),
                  const SubLabelText(
                    'Select one to continue',
                    fontSize: 14,
                    color: AppColors.grey600,
                  ),
                  const SizedBox(height: 20),

                  // Reason options
                  PlannedReasonTile(
                    icon: Icons.people_alt_rounded,
                    title: 'Wedding in the family',
                    subtitle: 'Marriage function',
                    onTap: () => _onReasonSelected(context, 'Wedding in the family'),
                  ),
                  PlannedReasonTile(
                    icon: Icons.agriculture_rounded,
                    title: 'Farming Work',
                    subtitle: 'Harvest or Land work',
                    onTap: () => _onReasonSelected(context, 'Farming Work'),
                  ),
                  PlannedReasonTile(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Festival',
                    subtitle: 'Go home for a festival',
                    onTap: () => _onReasonSelected(context, 'Festival'),
                  ),
                  PlannedReasonTile(
                    icon: Icons.more_horiz_rounded,
                    title: 'Something else',
                    subtitle: 'You need to add a short note',
                    onTap: () => _onReasonSelected(context, 'Something else'),
                  ),

                  const SizedBox(height: 16),

                  // Info banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: AppColors.grey700,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LabelText(
                                'Apply early to get instant approval',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 2),
                              SubLabelText(
                                'Even 1 day ahead can be enough for short leave',
                                fontSize: 12,
                                color: AppColors.grey700,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onReasonSelected(BuildContext context, String reason) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlannedLeaveDatesScreen(selectedReason: reason),
      ),
    );
  }
}
