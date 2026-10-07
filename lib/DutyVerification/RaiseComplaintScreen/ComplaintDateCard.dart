import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';


class ComplaintDateCard extends StatelessWidget {
  const ComplaintDateCard({super.key});

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

          Row(
            children: [

              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.red700,
                size: 22,
              ),

              const SizedBox(width: 10),

              Text(
                'complaint_date'.tr(),
                style: const TextStyle(
                  color: AppColors.red700,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),


            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.border,
              ),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Row(
              children: [

                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.red700,
                  size: 26,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        'date_cant_be_changed'.tr(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Friday, 11 September 2026',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.lock_outline,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}