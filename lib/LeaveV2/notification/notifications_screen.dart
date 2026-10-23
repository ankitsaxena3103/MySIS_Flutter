/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../common/widgets/common_text.dart';
import '../../constants/app_colors.dart';
import 'notification_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
          'Notifications',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Today section
          const SubLabelText(
            'Today',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.grey700,
          ),
          const SizedBox(height: 12),

          NotificationItem(
            iconBgColor: const Color(0xFFBF8A00),
            // brown/gold
            icon: Icons.hourglass_bottom_rounded,
            title: '22 leave days lapse on 31 Dec',
            subtitle: 'Use them before they are gone',
            time: '9:00 AM',
            onTap: () {},
          ),
          NotificationItem(
            iconBgColor: AppColors.green600,
            icon: Icons.bolt_rounded,
            title: 'Emergency Leave auto-approved',
            subtitle: 'No reply from Area Officer in 2 hours',
            time: '2:45 PM',
            onTap: () {},
          ),
          NotificationItem(
            iconBgColor: const Color(0xFFF9A825),
            // amber
            icon: Icons.access_time_rounded,
            title: 'Request sent to Area Officer',
            subtitle: 'Reply expected by 2:45 PM',
            time: '12:45 PM',
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // Earlier section
          const SubLabelText(
            'Earlier',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.grey700,
          ),
          const SizedBox(height: 12),

          NotificationItem(
            iconBgColor: AppColors.green600,
            icon: Icons.check_rounded,
            title: 'Planned Leave Approved',
            subtitle: '10-12 Oct • approved instantly',
            time: '28 Sep',
            onTap: () {},
          ),
          NotificationItem(
            iconBgColor: AppColors.red900,
            icon: Icons.close_rounded,
            title: 'Planned Leave rejected',
            subtitle: 'Tap to see the reason',
            time: '20 Mar',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
