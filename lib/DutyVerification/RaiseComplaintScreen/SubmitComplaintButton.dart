import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';

class SubmitComplaintButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const SubmitComplaintButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.white,
          ),
        )
            : const Icon(Icons.send_outlined, size: 22),
        label: Text(
          isLoading ? 'please_wait'.tr() : 'submit_complaint'.tr(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red700,
          disabledBackgroundColor: AppColors.red700.withOpacity(0.6),
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}