/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../common/widgets/common_text.dart';
import '../../constants/app_colors.dart';
import 'emergency_leave_dates_screen.dart';
import 'emergency_step_indicator.dart';
import 'widgets/emergency_reason_tile.dart';

class EmergencyLeaveReasonScreen extends StatelessWidget {
  const EmergencyLeaveReasonScreen({super.key});

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
          'Emergency Leave',
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
          const EmergencyStepIndicator(currentStep: 1),

          // Content
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
                  EmergencyReasonTile(
                    icon: Icons.people_alt_rounded,
                    title: 'Family emergency',
                    subtitle: 'Something urgent came up',
                    onTap: () => _onReasonSelected(context, 'Family emergency'),
                  ),
                  EmergencyReasonTile(
                    icon: Icons.thermostat_rounded,
                    title: 'I am sick',
                    subtitle: 'Fever, Injury or illness',
                    onTap: () => _onReasonSelected(context, 'I am sick'),
                  ),
                  EmergencyReasonTile(
                    icon: Icons.work_rounded,
                    title: 'Personal work',
                    subtitle: 'Bank, documents, urgent work',
                    onTap: () => _onReasonSelected(context, 'Personal work'),
                  ),
                  EmergencyReasonTile(
                    icon: Icons.more_horiz_rounded,
                    title: 'Something else',
                    subtitle: 'You need to add a short note',
                    onTap: () => _onReasonSelected(context, 'Something else'),
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
        builder: (_) => EmergencyLeaveDatesScreen(selectedReason: reason),
      ),
    );
  }
}
