import 'package:flutter/material.dart';
import 'package:mysis/DutyVerification/AttendanceConsentScreen/AttendanceConsentScreen.dart';
import 'package:mysis/DutyVerification/DutySummaryModule/summary_section.dart';
import 'package:mysis/constants/app_colors.dart';

import '../models/attendance_day.dart';
import '../repo/attendance_grouper.dart';
import '../repo/attendance_service.dart';
import 'bottom_action_button.dart';
import 'duty_row.dart';
import 'duty_table_header.dart';

class DutySummaryScreen extends StatefulWidget {
  /// Android extra "isCompleted": button shows "Back to Home"
  /// and returns COMPLETED instead of opening the consent screen.
  final bool isCompleted;

  /// Supply from your session/prefs (CSShearedPrefence equivalents).
  final String user;
  final String deviceToken;
  final String password;
  final String mPin;

  const DutySummaryScreen({
    super.key,
    this.isCompleted = false,
    required this.user,
    required this.deviceToken,
    required this.password,
    required this.mPin,
  });

  @override
  State<DutySummaryScreen> createState() => _DutySummaryScreenState();
}

class _DutySummaryScreenState extends State<DutySummaryScreen> {
  List<AttendanceDay> _days = [];
  String _startDate = '';
  String _endDate = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final r = await AttendanceService.fetch(
        user: widget.user,
        deviceToken: widget.deviceToken,
        password: widget.password,
        pin: widget.mPin
      );
      if (!mounted) return;
      setState(() {
        _startDate = r.startDate;
        _endDate = r.endDate;
        _days =
            AttendanceGrouper.groupByDate(r.records, r.startDate, r.endDate);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  Future<void> _onNext() async {
    if (widget.isCompleted) {
      Navigator.pop(context, 'COMPLETED');
      return;
    }

    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        // !! Add startDate / endDate params to AttendanceConsentScreen
        builder: (_) => AttendanceConsentScreen(
          startDate: _startDate,
          endDate: _endDate,
        ),
      ),
    );

    if (result == 'COMPLETED' && mounted) {
      Navigator.pop(context, 'COMPLETED');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            SummarySection(
              confirmed: AttendanceGrouper.countConfirmed(_days),
              claim: AttendanceGrouper.countClaimPending(_days),
              rejected: AttendanceGrouper.countRejected(_days),
              total: _days.length,
            ),
            Expanded(child: _buildContent()),
            BottomActionButton(
              label: widget.isCompleted ? 'Back to Home' : 'Next',
              onTap: _loading ? null : _onNext,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.red),
      ),
      title: Text(
        'Duty Summary',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              TextButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        const DutyTableHeader(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _days.length,
            itemBuilder: (_, i) => DutyRow(day: _days[i]),
          ),
        ),
      ],
    );
  }
}