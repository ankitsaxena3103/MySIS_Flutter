/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../common/widgets/common_text.dart';
import '../../constants/app_colors.dart';

class LeaveTypeCard extends StatelessWidget {
  final Color iconBgColor;
  final IconData icon;
  final String title;
  final String usedText;
  final String daysLeftLabel;
  final Widget? progressSection;
  final String infoTitle;
  final String infoSubtitle;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback? onApply;

  const LeaveTypeCard({
    super.key,
    required this.iconBgColor,
    required this.icon,
    required this.title,
    required this.usedText,
    required this.daysLeftLabel,
    this.progressSection,
    required this.infoTitle,
    required this.infoSubtitle,
    required this.buttonText,
    required this.buttonColor,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LabelText(title),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  LabelText(
                    usedText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  SubLabelText(daysLeftLabel),
                ],
              ),
            ],
          ),

          if (progressSection != null) ...[
            const SizedBox(height: 14),
            progressSection!,
          ],

          const SizedBox(height: 14),

          // Yellow info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelText(
                  infoTitle,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brown700,
                ),
                const SizedBox(height: 2),
                SubLabelText(
                  infoSubtitle,
                  fontSize: 12,
                  color: AppColors.grey700,
                  height: 1.3,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Apply button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
