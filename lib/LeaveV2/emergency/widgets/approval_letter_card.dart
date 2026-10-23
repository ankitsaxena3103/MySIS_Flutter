/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../../common/widgets/common_text.dart';
import '../../../constants/app_colors.dart';

class ApprovalLetterCard extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final VoidCallback? onDownload;

  const ApprovalLetterCard({
    super.key,
    this.fileName = 'leave_approval_letter.pdf',
    this.fileSize = '2.4 MB',
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Document preview area
          Container(
            width: double.infinity,
            height: 140,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Stack(
              children: [
                // Fake document content (UI only)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SubLabelText(
                          'SAMPLE LEAVE APPROVAL LETTER',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SubLabelText(
                        '[Your Company Name]\n[Your Company Address]\n...',
                        fontSize: 10,
                        color: AppColors.grey500,
                        height: 1.4,
                      ),
                    ],
                  ),
                ),
                // Side black bars to mimic document edges
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 18, color: AppColors.grey800),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 18, color: AppColors.grey800),
                ),
              ],
            ),
          ),

          // PDF row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                // PDF icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: AppColors.red700,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelText(
                        fileName,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 2),
                      SubLabelText(
                        fileSize,
                        fontSize: 12,
                        color: AppColors.grey600,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onDownload,
                  child: Icon(
                    Icons.download_rounded,
                    color: AppColors.grey600,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


