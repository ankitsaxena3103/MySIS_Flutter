/*
 * Created by Ashu Rajput on 23-10-2026.
 */

import 'package:flutter/material.dart';

import '../../common/widgets/common_text.dart';
import '../../constants/app_colors.dart';
import '../emergency/widgets/status_timeline.dart';

class PlannedLeaveRequestSentScreen extends StatelessWidget {
  final int days;
  final String dateRange; // e.g. "1 - 2 Oct"

  const PlannedLeaveRequestSentScreen({
    super.key,
    required this.days,
    required this.dateRange,
  });

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
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                children: [
                  // Success icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.green600,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const LabelText(
                    'Request Sent',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 6),
                  SubLabelText(
                    '$days days • $dateRange',
                    fontSize: 14,
                    color: AppColors.grey600,
                  ),

                  const SizedBox(height: 28),

                  // Status card
                  Container(
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
                        // Header
                        Row(
                          children: [
                            const LabelText(
                              'Current Status',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 13,
                                    color: Color(0xFFE65100),
                                  ),
                                  const SizedBox(width: 4),
                                  SubLabelText(
                                    'Pending',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFE65100),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Divider(color: AppColors.grey200, height: 1),
                        const SizedBox(height: 16),

                        // Timeline
                        const StatusTimeline(
                          steps: [
                            TimelineStep(
                              title: 'Request Submitted',
                              subtitle: 'Today, 12:45 PM',
                              state: TimelineStepState.completed,
                            ),
                            TimelineStep(
                              title: 'Area Officer reviewing',
                              subtitle: 'Reply by 2:45 PM',
                              state: TimelineStepState.current,
                            ),
                            TimelineStep(
                              title: 'Leave approved',
                              subtitle: 'Auto-approved at 2:45 PM if there is no reply',
                              state: TimelineStepState.upcoming,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Info banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
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
                                      'You will get a notification',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(height: 2),
                                    SubLabelText(
                                      'As soon as your Area Officer decides',
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
                ],
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
                  // Done
                  SizedBox(
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
                  const SizedBox(height: 12),

                  // View Status
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Navigate to status / My Leaves detail
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
                      child: const Text('View Status'),
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
