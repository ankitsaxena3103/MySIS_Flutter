import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';

/// Order matters: index + 1 is sent to the server as COMPLAINT_CATEGORY
/// (same as the Android spinner position, where 0 = "Select category").
const List<String> complaintCategories = [
  'Incorrect shift assigned',
  'Attendance not recorded',
  'Wrong punch time',
  'Unauthorized deduction',
  'Post mismatch',
  'Other',
];

class ComplaintDetailsCard extends StatelessWidget {
  final TextEditingController descriptionController;

  /// 1-based category value (null = nothing selected)
  final int? selectedCategory;
  final ValueChanged<int?> onCategoryChanged;

  const ComplaintDetailsCard({
    super.key,
    required this.descriptionController,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined,
                  color: AppColors.red700, size: 22),
              const SizedBox(width: 10),
              Text(
                'complaint_details'.tr(),
                style: const TextStyle(
                  color: AppColors.red700,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // CATEGORY
          Text(
            '${'complaint_category'.tr()} *',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: selectedCategory,
            isExpanded: true,
            hint: const Text(
              '— Select category —',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
            ),
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: _border(AppColors.border),
              enabledBorder: _border(AppColors.border),
              focusedBorder: _border(AppColors.red700),
            ),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.textSecondary),
            items: List.generate(
              complaintCategories.length,
                  (i) => DropdownMenuItem<int>(
                value: i + 1,
                child: Text(
                  complaintCategories[i],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            onChanged: onCategoryChanged,
          ),

          const SizedBox(height: 20),

          // PROBLEM
          Text(
            '${'describe_issue'.tr()} *',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descriptionController,
            maxLines: 5,
            maxLength: 500,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'issue_hint'.tr(),
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
              contentPadding: const EdgeInsets.all(16),
              border: _border(AppColors.border),
              enabledBorder: _border(AppColors.border),
              focusedBorder: _border(AppColors.red700),
            ),
          ),
        ],
      ),
    );
  }
}