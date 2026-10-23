/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysis/LeaveV2/planned_leave/planned_leave_request_sent_screen.dart';

import '../../common/widgets/common_text.dart'; // adjust path if needed
import '../../constants/app_colors.dart';
import 'widgets/planned_review_card.dart';
import 'widgets/planned_step_indicator.dart';

class PlannedLeaveConfirmScreen extends StatefulWidget {
  final String selectedReason;
  final DateTime fromDate;
  final DateTime toDate;

  const PlannedLeaveConfirmScreen({
    super.key,
    required this.selectedReason,
    required this.fromDate,
    required this.toDate,
  });

  @override
  State<PlannedLeaveConfirmScreen> createState() => _PlannedLeaveConfirmScreenState();
}

class _PlannedLeaveConfirmScreenState extends State<PlannedLeaveConfirmScreen> {
  final TextEditingController _noteController = TextEditingController();
  final DateFormat _dayFormat = DateFormat('EEE, d MMM'); // Mon, 1 Oct

  int get _days {
    return widget.toDate.difference(widget.fromDate).inDays + 1;
  }

  // Static remaining balance for UI (replace with real balance later)
  int get _balanceDays => 18 - _days; // example: 18 available

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.black,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const LabelText(
          'Planned Leave',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          const PlannedStepIndicator(currentStep: 3),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabelText(
                    'Review dates',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 16),
                  PlannedReviewCard(
                    fromDate: _dayFormat.format(widget.fromDate),
                    toDate: _dayFormat.format(widget.toDate),
                    reason: widget.selectedReason,
                    days: _days,
                    balanceDays: _balanceDays,
                    onEdit: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 28),
                  const LabelText(
                    'Add a note • optional',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteController,
                          maxLines: 2,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type, or tap the mic to speak',
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: AppColors.grey500,
                            ),
                            filled: true,
                            fillColor: AppColors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.grey300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.grey300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.green700,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          // TODO: Voice input
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppColors.red900,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.mic_rounded,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Continue button
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red900,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onContinue() {
    final days = widget.toDate.difference(widget.fromDate).inDays + 1;
    final dateRange =
        '${DateFormat('d MMM').format(widget.fromDate)} - ${DateFormat('d MMM').format(widget.toDate)}';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PlannedLeaveRequestSentScreen(
          days: days,
          dateRange: dateRange,
        ),
      ),
    );
  }
}
