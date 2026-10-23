/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';
import 'package:mysis/LeaveV2/myleaves/my_leaves_screen.dart';

import '../../common/widgets/common_text.dart';
import '../../constants/app_colors.dart';
import '../emergency/emergency_leave_reason_screen.dart';
import '../planned_leave/planned_leave_reason_screen.dart';
import 'leave_type_card.dart';
import 'my_leaves_tile.dart';

class LeaveDashboardScreen extends StatelessWidget {
  const LeaveDashboardScreen({super.key});

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
          'Leaves',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 8, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: LabelText(
                '18 days of leaves available this year.',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Emergency Leave
            LeaveTypeCard(
              iconBgColor: AppColors.red900,
              icon: Icons.notifications_rounded,
              title: 'Emergency Leave',
              usedText: '0/6',
              daysLeftLabel: 'days left',
              infoTitle: 'You can still apply for extra days',
              infoSubtitle: 'Extra days are subject to approval from Area Officer or HR.',
              buttonText: 'Apply Emergency Leave',
              buttonColor: AppColors.red900,
              onApply: () {
                // Navigate to Emergency Leave Reason Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmergencyLeaveReasonScreen(),
                    // builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Planned Leave
            LeaveTypeCard(
              iconBgColor: AppColors.green800,
              icon: Icons.calendar_today_rounded,
              title: 'Planned Leave',
              usedText: '18/30',
              daysLeftLabel: 'days left',
              progressSection: _buildPlannedProgress(),
              infoTitle: 'Unused days lapse on 31st Dec',
              infoSubtitle: '210 days left',
              buttonText: 'Apply Planned Leave',
              buttonColor: AppColors.green800,
              onApply: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlannedLeaveReasonScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            MyLeavesTile(onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyLeavesScreen(),
                ),
              );
            }),

            const SizedBox(height: 28),

            Center(
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.grey600,
                          width: 1.4,
                        ),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 14,
                        color: AppColors.grey700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SubLabelText(
                      'How my leave works',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey800,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlannedProgress() {
    const double progress = 18 / 30;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.grey200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green600),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SubLabelText('30 days every year'),
            SubLabelText('12 days used'),
          ],
        ),
      ],
    );
  }
}
