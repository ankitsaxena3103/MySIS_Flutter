/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../common/widgets/common_text.dart';
import '../../constants/app_colors.dart';

class LeaveFilterChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final int pendingCount;

  const LeaveFilterChips({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    this.pendingCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      'All',
      pendingCount > 0 ? 'Pending($pendingCount)' : 'Pending',
      'Approved',
      'Rejected',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: index == filters.length - 1 ? 0 : 8),
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.red900 : AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? AppColors.red900 : AppColors.grey300,
                    width: 1,
                  ),
                ),
                child: CommonText(
                  filters[index],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.white : AppColors.grey700,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
