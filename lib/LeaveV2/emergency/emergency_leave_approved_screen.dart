/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../common/widgets/common_text.dart'; // adjust path if needed
import '../../constants/app_colors.dart';
import 'widgets/approval_letter_card.dart';
import 'widgets/approved_details_card.dart';

class EmergencyLeaveApprovedScreen extends StatelessWidget {
  final String fromDate;
  final String toDate;
  final String reason;
  final String backOnDuty;
  final String approvedAt; // e.g. "1:20 PM"

  const EmergencyLeaveApprovedScreen({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.backOnDuty,
    this.approvedAt = '1:20 PM',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Column(
        children: [
          // Green header
          Container(
            width: double.infinity,
            color: AppColors.green700,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // AppBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: AppColors.white,
                          ),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Success icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.green700,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const LabelText(
                    'Leave approved',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: 6),
                  SubLabelText(
                    'by your Area Officer at $approvedAt',
                    fontSize: 14,
                    color: AppColors.white.withOpacity(0.9),
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    // Details card
                    ApprovedDetailsCard(
                      fromDate: fromDate,
                      toDate: toDate,
                      reason: reason,
                      backOnDuty: backOnDuty,
                    ),

                    const SizedBox(height: 16),

                    // Approval letter
                    ApprovalLetterCard(
                      onDownload: () {
                        // TODO: Download / open PDF
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Done button
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red900,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
