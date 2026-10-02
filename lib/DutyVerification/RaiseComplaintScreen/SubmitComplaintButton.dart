import 'package:flutter/material.dart';
import 'package:mysis/DutyVerification/DutySummaryScreen/DutySummaryScreen.dart';
import 'package:mysis/constants/app_colors.dart';


class SubmitComplaintButton extends StatelessWidget {
  const SubmitComplaintButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
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
        label: const Text(
          'SUBMIT COMPLAINT',
          style: TextStyle(
            fontSize: 16,
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
