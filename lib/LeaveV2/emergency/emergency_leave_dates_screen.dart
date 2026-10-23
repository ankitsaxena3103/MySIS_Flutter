/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../common/widgets/common_text.dart'; // adjust path if needed
import '../../constants/app_colors.dart';
import 'emergency_leave_confirm_screen.dart';
import 'emergency_step_indicator.dart';
import 'widgets/day_counter.dart';
import 'widgets/start_day_card.dart';

class EmergencyLeaveDatesScreen extends StatefulWidget {
  final String selectedReason;

  const EmergencyLeaveDatesScreen({
    super.key,
    required this.selectedReason,
  });

  @override
  State<EmergencyLeaveDatesScreen> createState() => _EmergencyLeaveDatesScreenState();
}

class _EmergencyLeaveDatesScreenState extends State<EmergencyLeaveDatesScreen> {
  // 0 = Today, 1 = Tomorrow
  int _selectedStart = 0;
  int _days = 4;

  // Static dates matching screenshot (UI only)
  // In real app these would come from DateTime.now()
  final String _todayLabel = 'Mon, 1 Oct';
  final String _tomorrowLabel = 'Tue, 2 Oct';

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
          // Step indicator – Reason completed, Dates active
          const EmergencyStepIndicator(currentStep: 2),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabelText(
                    'When does it start?',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 16),

                  // Today / Tomorrow cards
                  Row(
                    children: [
                      StartDayCard(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Today',
                        subtitle: _todayLabel,
                        isSelected: _selectedStart == 0,
                        onTap: () => setState(() => _selectedStart = 0),
                      ),
                      const SizedBox(width: 12),
                      StartDayCard(
                        icon: Icons.wb_twilight_outlined,
                        title: 'Tomorrow',
                        subtitle: _tomorrowLabel,
                        isSelected: _selectedStart == 1,
                        onTap: () => setState(() => _selectedStart = 1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const LabelText(
                    'How Many days?',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 20),

                  // Day counter + pills
                  DayCounter(
                    days: _days,
                    maxDays: 6,
                    onChanged: (value) => setState(() => _days = value),
                  ),

                  const SizedBox(height: 24),

                  // Date range summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: AppColors.grey600,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SubLabelText(
                            _buildDateSummary(),
                            fontSize: 13,
                            color: AppColors.grey700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Continue button
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

  String _buildDateSummary() {
    // UI-only static summary matching screenshot style
    // Real implementation would calculate actual dates
    if (_selectedStart == 0) {
      // Starting Today
      return 'Mon, 1 Oct - Thu, 4 Oct | back on 5th Oct';
    } else {
      return 'Tue, 2 Oct - Fri, 5 Oct | back on 6th Oct';
    }
  }

  void _onContinue() {
    // - selectedReason
    // - startDay (Today / Tomorrow)
    // - number of days

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmergencyLeaveConfirmScreen(
          selectedReason: widget.selectedReason,
          startToday: _selectedStart == 0,
          days: _days,
        ),
      ),
    );
  }
}
