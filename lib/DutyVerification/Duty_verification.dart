import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/DutyVerification/DutySummaryModule/DutySummaryScreen.dart';
import 'package:mysis/DutyVerification/Missing_Claim.dart';
import 'package:mysis/DutyVerification/repo/attendance_repository.dart';
import 'package:mysis/constants/app_colors.dart';

import 'models/attendance_verify_model.dart';

class DutyVerificationScreen extends StatefulWidget {
  // Previously hard-coded; now passed in (Android: CSShearedPrefence values)
  final String user;
  final String deviceToken;
  final String password;
  final String mPin;

  const DutyVerificationScreen({
    super.key,
    required this.user,
    required this.deviceToken,
    required this.password,
    required this.mPin,
  });

  @override
  State<DutyVerificationScreen> createState() => _DutyVerificationScreenState();
}

class _DutyVerificationScreenState extends State<DutyVerificationScreen> {
  final _repo = AttendanceRepository();
  final _stripController = ScrollController();

  List<DateEntry> _entries = [];
  int _selectedIndex = 0;
  int _allowedMaxIndex = 0;

  bool _loading = true;
  bool _submitting = false;
  String? _error;

  DateEntry? get _entry =>
      _entries.isEmpty ? null : _entries[_selectedIndex];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _stripController.dispose();
    super.dispose();
  }

  // ============================================================
  // DATA  (callAttendanceAPi + onGetResponse)
  // ============================================================
  Future<void> _load({bool keepSelection = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _repo.fetchAttendance(
        user: widget.user,
        deviceToken: widget.deviceToken,
        password: widget.password,
        pin: widget.mPin,
      );
      if (!mounted) return;
      setState(() {
        _entries = result.entries;
        _allowedMaxIndex = 0;
        _loading = false;
        if (!keepSelection || _selectedIndex >= _entries.length) {
          _selectedIndex = 0;
        }
      });
      if (_entries.isNotEmpty) _scrollStripTo(_selectedIndex);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  // ============================================================
  // NAVIGATION RULES  (onChipSelected / selectDate)
  // ============================================================
  void _onChipTap(int position) {
    if (position < 0 || position >= _entries.length) return;
    final target = _entries[position];

    final allowed = target.isSubmitted ||
        position <= _allowedMaxIndex ||
        (position > 0 && _entries[position - 1].isSubmitted);

   if(target.viewType==1){
     _selectDate(position);

   }else{
     if (!allowed) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           backgroundColor: const Color(0xFFDC2626),
           content: Text('verify_complete_claim'.tr(),
               style: const TextStyle(color: Colors.white)),
         ),
       );
       return;
     }
   }

    _selectDate(position);
  }

  void _selectDate(int index) {
    if (index < 0 || index >= _entries.length) return;
    setState(() => _selectedIndex = index);
    _scrollStripTo(index);
  }

  void _scrollStripTo(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_stripController.hasClients) return;
      final max = _stripController.position.maxScrollExtent;
      _stripController.animateTo(
        (index * 61.0).clamp(0.0, max),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  /// findNextPending(from): next index, or -1 when at the end
  int _findNext(int from) => from < _entries.length ? from : -1;

  // ============================================================
  // VERIFIED & NEXT  (btnVerifiedNext)
  // ============================================================
  Future<void> _onVerifiedNext() async {
    final entry = _entry;
    if (entry == null || _submitting) return;

    // Day without records → just move on, no API call
    if (entry.records.isEmpty) {
      setState(() => entry.isSubmitted = true);
      _goNext();
      return;
    }

    setState(() => _submitting = true);
    try {
      // body: [{"ID": rec.id}, ...]
      await _repo.verifyRecords(entry.records.map((r) => r.id).toList());
      if (!mounted) return;
      setState(() {
        entry.markVerified();
        _submitting = false;
      });
      _goNext();
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showInfo(e.toString());
    }
  }

  void _goNext() {
    final next = _findNext(_selectedIndex + 1);
    if (next != -1) {
      if (next > _allowedMaxIndex) _allowedMaxIndex = next;
      _selectDate(next);
    }
  }

  // ============================================================
  // MISSING CLAIM  (btnMissingClaim + onRecordSubmitted)
  // ============================================================
  Future<void> _onMissingClaim() async {
    final entry = _entry;
    if (entry == null) return;

    // TODO: give MissingClaimScreen these params (Android passes them to
    // MissingClaimFragment.newInstance(fullDateLabel, apiDate, records)):
    //   MissingClaimScreen(dateLabel: entry.fullDateLabel,
    //                      apiDate: entry.apiDate, records: entry.records)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MissingClaimScreen()),
    );

    if (result == true) {
      await _load(keepSelection: true); // re-fetch, stay on same day
    }
  }

  // ============================================================
  // SUMMARY  (btnSummary + signatureLauncher)
  // ============================================================
  Future<void> _onSummary() async {
    final last = _entries.last;
    // Android also passes START_DATE / END_DATE / isCompleted / isViewType:
    //   last.startDateRange, last.endDateRange, last.isCompleted, last.viewType
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DutySummaryScreen(
          user: widget.user,
          deviceToken: widget.deviceToken,
          password: widget.password,
          mPin: widget.mPin,
        ),
      ),
    );
    // Android: SIGNATURE_STATUS == COMPLETED → finish()
    if (result == true && mounted) Navigator.pop(context, true);
  }

  // ============================================================
  // LEAVE CONFIRMATION  (onBackPressed / toolbar click)
  // ============================================================
  Future<void> _confirmLeave() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alert'),
        content: Text('leave_screen'.tr()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('cancel'.tr())),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('ok'.tr())),
        ],
      ),
    );
    if (leave == true && mounted) Navigator.pop(context);
  }

  void _showInfo(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text('ok'.tr())),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final monthYear = _entries.isNotEmpty ? _entries.first.monthYearTag : '';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _appBar(monthYear),
        body: SafeArea(top: false, child: _body(monthYear)),
      ),
    );
  }

  PreferredSizeWidget _appBar(String monthYear) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        color: AppColors.white,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: _confirmLeave,
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.red, size: 20),
                  ),
                ),
                const SizedBox(width: 3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('duty_verification'.tr(),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 1),
                    Text(monthYear,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(String monthYear) {
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
              ElevatedButton(onPressed: _load, child: Text('retry'.tr())),
            ],
          ),
        ),
      );
    }

    if (_entries.isEmpty) {
      return Center(child: Text('no_data_found'.tr()));
    }

    final entry = _entry!;
    return Column(
      children: [
        _dateStrip(monthYear),
        _selectedDateHeader(entry),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 3, 16, 14),
            child: entry.records.isEmpty
                ? _emptyDayCard()
                : Column(
              children: [
                for (final r in entry.records) ...[
                  _mainDutyCard(r),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
        _bottomButtons(entry),
      ],
    );
  }

  // ============================================================
  // DATE STRIP
  // ============================================================
  Widget _dateStrip(String monthYear) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      child: Column(
        children: [
          Text(monthYear,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          SizedBox(
            height: 72,
            child: ListView.builder(
              controller: _stripController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final item = _entries[index];
                final isSelected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () => _onChipTap(index),
                  child: SizedBox(
                    width: 61,
                    child: Column(
                      children: [
                        Container(
                          width: 58,
                          height: 54,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.red : AppColors.grey50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item.dayNumber,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.red800)),
                              const SizedBox(height: 1),
                              Text(item.dayName,
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.red800)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.isSubmitted
                                ? AppColors.green500
                                : AppColors.orange700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(height: 1, color: AppColors.divider),
        ],
      ),
    );
  }

  Widget _selectedDateHeader(DateEntry entry) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(entry.fullDateLabel,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor(entry.overallStatus),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(entry.overallStatus,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Approved':
        return AppColors.green600;
      case 'Rejected':
        return AppColors.red;
      default: // Pending / Absent
        return AppColors.orange700;
    }
  }

  // ============================================================
  // BOTTOM BUTTONS  (refreshBottomButtons)
  // ============================================================
  Widget _bottomButtons(DateEntry entry) {
    final isLast = _selectedIndex == _entries.length - 1;
    final showSummary = isLast && entry.isSubmitted;
    final canAct = entry.canAct && !_submitting;

    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 13),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: canAct ? _onVerifiedNext : null,
              icon: _submitting
                  ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.check_circle_outline, size: 20),
              label: Text('verified_next'.tr(),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green600,
                disabledBackgroundColor: AppColors.grey50,
                foregroundColor: AppColors.white,
                disabledForegroundColor: AppColors.textSecondary,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
              ),
            ),
          ),
          const SizedBox(height: 9),
          SizedBox(
            width: 270,
            height: 46,
            child: ElevatedButton(
              onPressed: canAct ? _onMissingClaim : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange700,
                disabledBackgroundColor: AppColors.grey50,
                foregroundColor: AppColors.white,
                disabledForegroundColor: AppColors.textSecondary,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
              ),
              child: Text('missing_claim'.tr(),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
            ),
          ),
          if (showSummary) ...[
            const SizedBox(height: 9),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _onSummary,
                icon: const Icon(Icons.arrow_forward_rounded, size: 21),
                label: Text('Duty_Verification_continue'.tr(),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // CARDS
  // ============================================================
  Widget _emptyDayCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          Icon(Icons.event_busy_outlined,
              size: 36, color: AppColors.textSecondary),
          const SizedBox(height: 8),
          Text('no_data_found'.tr(),
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _mainDutyCard(AttendanceVerifyModel r) {
    final topColor = _statusColor(r.status);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 9,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: topColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
            ),
          ),
          if (r.dutyOutMissing)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: _warningCard(r),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.shiftName,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 3),
                          Text(r.unitName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(r.unitCode,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 170,
                      child: _shiftTimingBox(
                          start: r.shiftStart, end: r.shiftEnd),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 20, color: AppColors.red),
                    const SizedBox(width: 6),
                    Text('Post Name :',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(r.postName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _approvedHourBox(r.approvedHrs)),
                    const SizedBox(width: 7),
                    Expanded(
                      child: _timeBox(
                        title: 'Duty In'.tr(),
                        time: r.dutyIn,
                        background: AppColors.green100,
                        titleColor: AppColors.green700,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: _timeBox(
                        title: 'Duty Out'.tr(),
                        time: r.dutyOut,
                        background: AppColors.red100,
                        titleColor: AppColors.red700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                _statusBar(r.status),
                if (r.isClaimSubmitted) ...[
                  const SizedBox(height: 8),
                  _claimBadge(r),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBar(String status) {
    final color = _statusColor(status);
    final label =
    status == 'Approved' ? 'attendance_verified'.tr() : status;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Icon(
              status == 'Approved'
                  ? Icons.check_circle_outline
                  : Icons.schedule_outlined,
              size: 21,
              color: color),
          const SizedBox(width: 7),
          Text('status_tag. :'.tr(),
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _claimBadge(AttendanceVerifyModel r) {
    final pending = r.isClaimPending;
    final color = pending ? AppColors.orange700 : AppColors.green600;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment_outlined, size: 18, color: color),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              pending
                  ? 'Claim submitted - pending'
                  : 'Claim submitted (${r.claimSubmittedOn})',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _warningCard(AttendanceVerifyModel r) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.red100.withOpacity(0.28),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.red100, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_outlined, size: 28, color: AppColors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('duty_out_not_recorded'.tr(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.red800)),
                const SizedBox(height: 5),
                Text('duty_out_not_recorded_message'.tr(),
                    style: TextStyle(
                        fontSize: 12, height: 1.35, color: AppColors.red800)),
                if (r.lateDutyIn) ...[
                  const SizedBox(height: 5),
                  Text('late_duty_in_duty_out_not_recorded'.tr(),
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: AppColors.red800)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shiftTimingBox({required String start, required String end}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightBlueGray,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('shift_timing'.tr(),
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black)),
          FittedBox(
            child: Row(
              children: [
                Text(start,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.green600)),
                const SizedBox(width: 5),
                Text('-',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary)),
                const SizedBox(width: 5),
                Text(end,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.red700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _approvedHourBox(int hours) {
    return Container(
      height: 66,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.lightBlueGray,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Approved_Hour'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 5),
          Text('$hours',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _timeBox({
    required String title,
    required String time,
    required Color background,
    required Color titleColor,
  }) {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: background.withOpacity(0.40),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: titleColor)),
          const SizedBox(height: 5),
          FittedBox(
            child: Text(time,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}