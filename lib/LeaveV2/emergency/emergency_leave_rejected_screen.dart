/*
 * Created by Ashu Rajput on 22-10-2026.
 */
import 'package:flutter/material.dart';

import '../../common/widgets/common_text.dart'; // adjust path if needed
import '../../constants/app_colors.dart';
import 'widgets/rejected_details_card.dart';

class EmergencyLeaveRejectedScreen extends StatelessWidget {
  final String officerMessage;
  final String dateRange;
  final String leaveSummary;
  final String rejectedAt; // e.g. "1:20 PM"
  final int remainingEmergencyLeaves;

  const EmergencyLeaveRejectedScreen({
    super.key,
    required this.officerMessage,
    required this.dateRange,
    required this.leaveSummary,
    this.rejectedAt = '1:20 PM',
    this.remainingEmergencyLeaves = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Column(
        children: [
          // Red header
          Container(
            width: double.infinity,
            color: AppColors.red900,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Back button
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

                  // X icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.red900,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const LabelText(
                    'Leave not approved',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: 6),
                  SubLabelText(
                    'by your Area Officer at $rejectedAt',
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
                    // Rejection details card
                    RejectedDetailsCard(
                      officerMessage: officerMessage,
                      dateRange: dateRange,
                      leaveSummary: leaveSummary,
                    ),

                    const SizedBox(height: 16),

                    // Safe leaves banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.green600,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                  'Your $remainingEmergencyLeaves emergency leaves are safe.',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                const SizedBox(height: 2),
                                const SubLabelText(
                                  'Nothing was deducted',
                                  fontSize: 13,
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
          ),

          // Bottom buttons
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  // Apply again
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate back to Reason screen to start new request
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        // Or push EmergencyLeaveReasonScreen if preferred
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Apply again'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Get help
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Open help / support
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.red900,
                        side: const BorderSide(
                          color: AppColors.red900,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Get help'),
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
}
