import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';

class BottomActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const BottomActionButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58,
      color: AppColors.red,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
