/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

/// Base reusable text widget with Roboto font.
class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final TextDecoration? decoration;

  const CommonText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color = AppColors.textPrimary,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        decoration: decoration,
      ),
    );
  }
}

/// Primary label text (titles, card titles, main labels)
class LabelText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  const LabelText(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.color = AppColors.textPrimary,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CommonText(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      height: height,
    );
  }
}

/// Sub-label / secondary text (hints, captions, "days left", "30 days every year" etc.)
class SubLabelText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  const SubLabelText(
    this.text, {
    super.key,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w400,
    this.color = AppColors.grey500,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CommonText(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      height: height,
    );
  }
}
