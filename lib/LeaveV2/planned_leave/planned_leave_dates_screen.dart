/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysis/LeaveV2/planned_leave/planned_leave_confirm_screen.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/widgets/common_text.dart'; // adjust path if needed
import '../../constants/app_colors.dart';
import 'widgets/planned_step_indicator.dart';

class PlannedLeaveDatesScreen extends StatefulWidget {
  final String selectedReason;

  const PlannedLeaveDatesScreen({
    super.key,
    required this.selectedReason,
  });

  @override
  State<PlannedLeaveDatesScreen> createState() => _PlannedLeaveDatesScreenState();
}

class _PlannedLeaveDatesScreenState extends State<PlannedLeaveDatesScreen> {
  DateTime _focusedDay = DateTime(2026, 10, 1);
  DateTime? _rangeStart = DateTime(2026, 10, 1);
  DateTime? _rangeEnd = DateTime(2026, 10, 2);
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final DateFormat _dayFormat = DateFormat('EEE, d MMM'); // Mon, 1 Oct
  final DateFormat _monthFormat = DateFormat('MMMM, yyyy'); // October, 2026

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
          const PlannedStepIndicator(currentStep: 2),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabelText(
                    'Pick your dates',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 6),
                  const SubLabelText(
                    'Select the dates for which you want to take leave',
                    fontSize: 14,
                    color: AppColors.grey600,
                  ),
                  const SizedBox(height: 16),

                  // From / To summary
                  Row(
                    children: [
                      Expanded(
                        child: _DateSummaryCard(
                          label: 'From',
                          value: _rangeStart != null ? _dayFormat.format(_rangeStart!) : '--',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DateSummaryCard(
                          label: 'To',
                          value: _rangeEnd != null
                              ? _dayFormat.format(_rangeEnd!)
                              : (_rangeStart != null ? _dayFormat.format(_rangeStart!) : '--'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Calendar card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2024, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      rangeSelectionMode: RangeSelectionMode.enforced,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      headerStyle: HeaderStyle(
                        titleCentered: false,
                        formatButtonVisible: false,
                        leftChevronIcon: _chevron(Icons.chevron_left_rounded),
                        rightChevronIcon: _chevron(Icons.chevron_right_rounded),
                        titleTextStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        headerPadding: const EdgeInsets.only(
                          left: 12,
                          right: 4,
                          bottom: 8,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey600,
                        ),
                        weekendStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey600,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: true,
                        cellMargin: const EdgeInsets.all(4),
                        defaultTextStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        weekendTextStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        outsideTextStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: AppColors.grey400,
                        ),
                        // Selected range
                        rangeStartDecoration: const BoxDecoration(
                          color: AppColors.green700,
                          shape: BoxShape.circle,
                        ),
                        rangeEndDecoration: const BoxDecoration(
                          color: AppColors.green700,
                          shape: BoxShape.circle,
                        ),
                        withinRangeDecoration: BoxDecoration(
                          color: AppColors.green700.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        rangeHighlightColor: AppColors.green700.withOpacity(0.12),
                        selectedDecoration: const BoxDecoration(
                          color: AppColors.green700,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.green700.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          color: AppColors.green700,
                        ),
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        // Handled by onRangeSelected
                      },
                      onRangeSelected: (start, end, focusedDay) {
                        setState(() {
                          _rangeStart = start;
                          _rangeEnd = end;
                          _focusedDay = focusedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
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
                  onPressed: _canContinue ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red900,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.grey300,
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

  bool get _canContinue => _rangeStart != null;

  Widget _chevron(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.green700.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: AppColors.green700),
    );
  }

  void _onContinue() {
    if (_rangeStart == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlannedLeaveConfirmScreen(
          selectedReason: widget.selectedReason,
          fromDate: _rangeStart!,
          toDate: _rangeEnd ?? _rangeStart!,
        ),
      ),
    );
  }
}

class _DateSummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _DateSummaryCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubLabelText(
            label,
            fontSize: 12,
            color: AppColors.grey500,
          ),
          const SizedBox(height: 4),
          LabelText(
            value,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
