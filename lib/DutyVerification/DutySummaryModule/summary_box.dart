import 'package:flutter/material.dart';

class SummaryBox extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final Color background;

  const SummaryBox({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: color),
          ),
          const SizedBox(height: 7),
          Text(
            count,
            style: TextStyle(
                fontSize: 29, fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}
