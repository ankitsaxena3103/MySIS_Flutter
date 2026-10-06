import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';

class DutyTableHeader extends StatelessWidget {
  const DutyTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final s = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    );

    return Container(
      height: 53,
      width: double.infinity,
      color: AppColors.red,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text('DATE', style: s)),
          Expanded(flex: 3, child: Text('DUTY COUNT', style: s)),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('STATUS', style: s),
            ),
          ),
        ],
      ),
    );
  }
}
