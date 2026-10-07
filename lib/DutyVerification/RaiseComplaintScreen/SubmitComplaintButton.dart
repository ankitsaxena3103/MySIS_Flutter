import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/DutyVerification/DutySummaryScreen/DutySummaryScreen.dart';
import 'package:mysis/constants/app_colors.dart';


class SubmitComplaintButton extends StatelessWidget {
  const SubmitComplaintButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DutySummaryScreen(),
            ),
          );
        },
        icon: const Icon(
          Icons.send_outlined,
          size: 22,
        ),
        label: Text(
          'submit_complaint'.tr(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red700,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
