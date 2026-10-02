import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';

class SelectShiftScreen extends StatelessWidget {
  const SelectShiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.red,
            size: 19,
          ),
        ),
        title: Text(
          "Select Shift",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _shiftItem(
            context,
            "8 Hrs Morning",
            "06:00 AM - 02:00 PM",
          ),
          const SizedBox(height: 10),
          _shiftItem(
            context,
            "12 Hrs Morning",
            "08:00 AM - 08:00 PM",
          ),
          const SizedBox(height: 10),
          _shiftItem(
            context,
            "8 Hrs Noon",
            "02:00 PM - 10:00 PM",
          ),
        ],
      ),
    );
  }

  Widget _shiftItem(
    BuildContext context,
    String title,
    String time,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, title);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
