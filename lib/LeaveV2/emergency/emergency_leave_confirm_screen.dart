/*
 * Created by Ashu Rajput on 22-10-2026.
 */
import 'package:flutter/material.dart';

import '../../common/widgets/common_text.dart'; // adjust path if needed
import '../../constants/app_colors.dart';
import 'emergency_leave_request_sent_screen.dart';
import 'emergency_step_indicator.dart';
import 'widgets/review_leave_card.dart';

class EmergencyLeaveConfirmScreen extends StatefulWidget {
  final String selectedReason;
  final bool startToday;
  final int days;

  const EmergencyLeaveConfirmScreen({
    super.key,
    required this.selectedReason,
    required this.startToday,
    required this.days,
  });

  @override
  State<EmergencyLeaveConfirmScreen> createState() => _EmergencyLeaveConfirmScreenState();
}

class _EmergencyLeaveConfirmScreenState extends State<EmergencyLeaveConfirmScreen> {
  final TextEditingController _noteController = TextEditingController();

  // Static dates matching screenshot style (UI only)
  String get _fromDate => widget.startToday ? 'Mon, 1 Oct' : 'Tue, 2 Oct';

  String get _toDate {
    // Simple static mapping for UI
    if (widget.startToday) {
      switch (widget.days) {
        case 1:
          return 'Mon, 1 Oct';
        case 2:
          return 'Tue, 2 Oct';
        case 3:
          return 'Wed, 3 Oct';
        case 4:
          return 'Thu, 4 Oct';
        default:
          return 'Thu, 4 Oct';
      }
    } else {
      switch (widget.days) {
        case 1:
          return 'Tue, 2 Oct';
        case 2:
          return 'Wed, 3 Oct';
        case 3:
          return 'Thu, 4 Oct';
        case 4:
          return 'Fri, 5 Oct';
        default:
          return 'Fri, 5 Oct';
      }
    }
  }

  // Remaining balance after this request (static for UI)
  int get _balanceDays => 6 - widget.days; // assuming 6 available

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
          'Emergency Leave',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          // Step indicator – Reason & Dates completed
          const EmergencyStepIndicator(currentStep: 3),

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

                  // Review card
                  ReviewLeaveCard(
                    fromDate: _fromDate,
                    toDate: _toDate,
                    reason: widget.selectedReason,
                    days: widget.days,
                    balanceDays: _balanceDays,
                    onEdit: () {
                      // Go back to Dates screen
                      Navigator.of(context).pop();
                    },
                  ),

                  const SizedBox(height: 28),

                  // Add note
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
                                color: AppColors.red900,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Mic button
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

          // Bottom Send request button
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onSendRequest,
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
                      Text('Send request'),
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

  void _onSendRequest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EmergencyLeaveRequestSentScreen(
          days: widget.days,
          dateRange: _fromDate.replaceAll(', ', ' ').split(' ').length > 2
              ? '${_fromDate.split(' ').last} - ${_toDate.split(' ').last}' // simple example
              : '1 - 2 Oct',
        ),
      ),
    );
  }
}
