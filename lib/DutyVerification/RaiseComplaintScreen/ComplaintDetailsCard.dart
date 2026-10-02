import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';

class ComplaintDetailsCard extends StatefulWidget {
  const ComplaintDetailsCard({super.key});

  @override
  State<ComplaintDetailsCard> createState() => _ComplaintDetailsCardState();
}

class _ComplaintDetailsCardState extends State<ComplaintDetailsCard> {
  final TextEditingController problemController = TextEditingController();

  String? selectedCategory;

  final List<String> categories = [
    'Incorrect shift assigned',
    'Attendance not recorded',
    'Wrong punch time',
    'Unauthorized deduction',
    'Post mismatch',
    'Other',
  ];

  @override
  void dispose() {
    problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE

          Row(
            children: const [
              Icon(
                Icons.description_outlined,
                color: AppColors.red700,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'COMPLAINT DETAILS',
                style: TextStyle(
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

          const Text(
            'Complaint Category *',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            value: selectedCategory,
            isExpanded: true,
            hint: const Text(
              '— Select category —',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.red700,
                ),
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
            ),
            items: categories.map(
              (category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),

          const SizedBox(height: 20),

          // PROBLEM

          const Text(
            'Tell us your problem *',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: problemController,
            maxLines: 5,
            maxLength: 500,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),

            decoration: InputDecoration(
              hintText: 'Type your problem here, OR use the voice note...',
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),

              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.border,
                ),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.border,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.red700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
