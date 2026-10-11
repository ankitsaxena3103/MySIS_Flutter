import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/DutyVerification/repo/missing_claim_service.dart';
import 'package:mysis/constants/app_colors.dart';
import 'package:uuid/uuid.dart';

import '../CommonViews/Utility.dart';
import '../SharedClasses/Preferences.dart';
import 'card_list_selection_screen.dart';
import 'models/attendance_record.dart';
import 'models/attendance_verify_model.dart';
import 'models/missing_claim_models.dart';

/// Flutter port of MissingClaimFragment.java
///
/// Pops with `true` when a claim is submitted (replaces
/// MissingClaimSubmitInterface.onRecordSubmitted):
///   final ok = await Navigator.push<bool>(context, MaterialPageRoute(
///       builder: (_) => MissingClaimScreen(...)));
class MissingClaimScreen extends StatefulWidget {
  /// ARG_API_DATE    "yyyy-MM-dd"
  final String apiDate;

  /// ARG_API_ATTENDANCE – existing claims, used for the duplicate check
  final List<AttendanceVerifyModel> records;

  const MissingClaimScreen({
    super.key,
    required this.apiDate,
    this.records = const [],
  });

  @override
  State<MissingClaimScreen> createState() => _MissingClaimScreenState();
}

class _MissingClaimScreenState extends State<MissingClaimScreen> {
  // ---- API state (getMissingDatFromAPI) ----
  MissingClaimApiResponse? _api;
  bool _loading = true;
  String? _loadError;
  late MissingClaimService service;

  // ---- Selections ----
  UnitModel? _unit;
  ShiftModel? _shift;
  PostModel? _post;
  ReasonModel? _reason;

  /// 24h "HH:mm" strings – same as selectedDutyIn / selectedDutyOut
  String _dutyIn = '';
  String _dutyOut = '';

  final TextEditingController _remarkCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _remarkCtrl.dispose();
    super.dispose();
  }

  // =============================================================
  // LOAD  (getMissingDatFromAPI + onGetResponse)
  // =============================================================
  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final res = await MissingClaimService.fetchMissingData();
      if (!mounted) return;
      if (res.isSuccess && res.data != null) {
        setState(() {
          _api = res;
          _loading = false;
        });
      } else {
        setState(() {
          _loadError = res.error ?? 'Something went wrong';
          _loading = false;
        });
      }
    } on NoInternetException {
      if (!mounted) return;
      setState(() {
        _loadError = 'no_internet'.tr();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.toString();
        _loading = false;
      });
    }
  }

  // =============================================================
  // SELECTION  (openCardListSelection + onXSelected)
  // =============================================================
  Future<void> _pickUnit() async {
    if (_shift != null) {
      setState(() {
        _shift = null;
        _post = null;
      });
    }
    final r = await Navigator.push<UnitModel>(
      context,
      MaterialPageRoute(
        builder: (_) => CardListSelectionScreen<UnitModel>(
          title: 'Select Unit',
          items: _api!.data!.unitList,
          selected: _unit,
        ),
      ),
    );
    if (r != null) setState(() => _unit = r);
  }

  Future<void> _pickShift() async {
    // getShiftsFilterListByUnit111(_api!.data!.shiftList,_unit?.unitCode??'');
    if (_unit == null) {
      _showError('please_select_unit'.tr());
    } else {
      final r = await Navigator.push<ShiftModel>(
        context,
        MaterialPageRoute(
          builder: (_) => CardListSelectionScreen<ShiftModel>(
            title: 'Select Shift',
            // items: _api!.data!.shiftList,
            items: getShiftsFilterListByUnit(
                _api!.data!.shiftList, _unit?.unitCode ?? ''),
            selected: _shift,
          ),
        ),
      );
      if (r != null) {
        setState(() {
          _shift = r;
          // onShiftSelected: auto-fill default duty times from shift
          _dutyIn = _hhmm(r.startTime);
          _dutyOut = _hhmm(r.endTime);
        });
      }
    }
  }

  getShiftsFilterListByUnit111(List<ShiftModel> all, String unitCode) {
    print('dfhgsjghjdjhhgg...unitCode${unitCode}');

    for (int i = 0; i < all.length; i++) {
      print('dfhgsjghjdjhhgg${all[i].unitCode}');
    }
    ;
  }

  List<ShiftModel> getShiftsFilterListByUnit(
          List<ShiftModel> all, String unitCode) =>
      all.where((s) => s.unitCode == unitCode).toList();

  List<PostModel> getPostFilterListByUnit(
          List<PostModel> all, String unitCode) =>
      all.where((s) => s.unitCode == unitCode).toList();

  Future<void> _pickPost() async {
    if (_unit == null) {
      _showError('please_select_unit'.tr());
    } else {
      final r = await Navigator.push<PostModel>(
        context,
        MaterialPageRoute(
          builder: (_) => CardListSelectionScreen<PostModel>(
            title: 'Select Post',
            // items: _api!.data!.postList,
            items: getPostFilterListByUnit(
                _api!.data!.postList, _unit?.unitCode ?? ''),
            selected: _post,
          ),
        ),
      );
      if (r != null) setState(() => _post = r);
    }
  }

  // =============================================================
  // TIME PICKER  (showTimePicker)
  // =============================================================
  Future<void> _pickTime({required bool isDutyIn}) async {
    final cur = isDutyIn ? _dutyIn : _dutyOut;
    var h = 6, m = 0;
    if (cur.isNotEmpty) {
      final p = cur.split(':');
      h = int.tryParse(p[0]) ?? 6;
      m = p.length > 1 ? (int.tryParse(p[1]) ?? 0) : 0;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: h, minute: m),
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;

    final t = '${picked.hour.toString().padLeft(2, '0')}:'
        '${picked.minute.toString().padLeft(2, '0')}';
    setState(() => isDutyIn ? _dutyIn = t : _dutyOut = t);
  }

  /// "HH:mm:ss" -> "HH:mm"
  String _hhmm(String t) {
    final p = t.split(':');
    if (p.length < 2) return t;
    return '${p[0].padLeft(2, '0')}:${p[1].padLeft(2, '0')}';
  }

  String _formatTime(String hhmm) {
    final p = hhmm.split(':');
    final t = TimeOfDay(
        hour: int.tryParse(p[0]) ?? 0, minute: int.tryParse(p[1]) ?? 0);
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${t.period == DayPeriod.am ? "AM" : "PM"}';
  }

  // =============================================================
  // SUBMIT  (setupSubmit -> validate -> postClaimDataOnServer)
  // =============================================================
  void _showError(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFDC2626),
        duration: const Duration(seconds: 2),
      ));
  }

  Future<void> _onSubmit() async {
    if (_submitting) return;

    if (_unit == null) return _showError('please_select_unit'.tr());
    if (_shift == null) return _showError('please_select_shift'.tr());
    if (_post == null) return _showError('please_select_post'.tr());
    if (_dutyIn.isEmpty) {
      return _showError('please_select_duty_in_time'.tr());
    }
    if (_dutyOut.isEmpty) {
      return _showError('please_select_duty_out_time'.tr());
    }
    if (_reason == null) return _showError('please_select_reason'.tr());
    if (_reason!.isOther && _remarkCtrl.text.trim().isEmpty) {
      return _showError('please_enter_a_remark'.tr());
    }

    // validate(): duplicate-claim check
    final exists = widget.records.any(
        (r) => r.unitCode == _unit!.unitCode && r.shiftId == _shift!.shiftId);
    if (exists) {
      _showError('claim_already_under_process'.tr());
      return;
    }

    setState(() => _submitting = true);
    try {
      print('Missing..CLAIM...BODY...SENDT ${await _buildPayload()}');
      final ok = await MissingClaimService.submitClaim([await _buildPayload()]);
      if (!mounted) return;
      if (ok) {
        Navigator.pop(context, true); // listener.onRecordSubmitted(true, ...)
      } else {
        _showError('Failed to submit claim');
      }
    } on NoInternetException {
      if (mounted) _showError('no_internet'.tr());
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('d MMMM yyyy').format(parsedDate);
  }
  /// Same JSON the Android code builds in postClaimDataOnServer()
  Future<Map<String, dynamic>> _buildPayload() async {
    final date = widget.apiDate;
    final shift = _shift!;

    final actStart = ClaimDateUtils.toDateTime(date, _dutyIn);
    final actEnd = ClaimDateUtils.dutyOutDateTime(actStart, _dutyOut);
    final shiftStart = ClaimDateUtils.toDateTime(date, shift.startTime);
    final shiftEnd = ClaimDateUtils.dutyOutDateTime(shiftStart, shift.endTime);
    final shiftDayEnd = ClaimDateUtils.dateAtMidnight(
        ClaimDateUtils.dutyOutDateTime(shiftStart, shift.endTime));

    final dutyMin = ClaimDateUtils.totalMinutes(actStart, actEnd);
    final shiftMin = ClaimDateUtils.totalMinutes(shiftStart, shiftEnd);
    final countedMin = dutyMin < shiftMin ? dutyMin : shiftMin;

    final f = ClaimDateUtils.format;

    return {
      'ID': const Uuid().v4(),
      'UNIT_CODE': _unit!.unitCode,
      'REGNO': await Preferences.getUserPreference(keyUserID) ?? '',
      'EMP_NAME': await Preferences.getUserPreference(keyUserName) ?? '',
      'UNIT_NAME': _unit!.siteName,
      'POST_ID': _post!.postId,
      'POST_NAME': _post!.postName,
      'SHIFT_ID': shift.shiftId,
      'SHIFT_NAME': shift.shiftName,
      'SHIFT_START_DATE': ClaimDateUtils.toDateTimeString(date, '00:00:00'),
      'SHIFT_END_DATE': shiftDayEnd,
      'ACT_START_TIME': f(actStart),
      'ACT_END_TIME': f(actEnd),
      'SHIFT_START_TIME': f(shiftStart),
      'SHIFT_END_TIME': f(shiftEnd),
      'IS_ABSENT': 0,
      'IS_REJECT': 0,
      'MODIFY_REASON_REMARK': '',
      'DUTY_STATUS': 'DUTY_OUT',
      'REASON_FOR_REJECTION': '',
      'FINAL_START_TIME': f(actStart),
      'FINAL_END_TIME': f(actEnd),
      'DUTY_MIN': countedMin,
      'CLAIM_REASON': _reason!.reasonId,
      'CLAIM_REMARK': _remarkCtrl.text.trim(),
      'SHIFT_MIN': shiftMin,
      'CLAIM_STATUS': 0,
      'DUTY_COUNT': ClaimDateUtils.calculateDayValue(countedMin, shiftMin),
      'CLAIM_SUBMITTED_ON': ClaimDateUtils.now(),
    };
  }

  // =============================================================
  // BUILD
  // =============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey400,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.red, size: 15),
        ),
        title: Text(
          'missing_claim'.tr(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_loadError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _claimDateCard(),
          const SizedBox(height: 10),
          _unitShiftPostCard(),
          const SizedBox(height: 10),
          _dutyTimeCard(),
          const SizedBox(height: 10),
          _reasonCard(),
          const SizedBox(height: 10),
          _submitButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // =============================================================
  // CLAIM DATE CARD
  // =============================================================
  Widget _claimDateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_note_outlined,
                  size: 15, color: AppColors.textPrimary),
              const SizedBox(width: 6),
              Text(
                'claim_date'.tr(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month_outlined,
                    size: 20, color: AppColors.textPrimary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'date_cant_be_changed'.tr(),
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formatDate(widget.apiDate), // tvMcDate
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.lock_outline,
                    size: 22, color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // UNIT / SHIFT / POST CARD
  // =============================================================
  Widget _unitShiftPostCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 17),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.business_outlined,
                  size: 19, color: AppColors.textPrimary),
              const SizedBox(width: 8),
              Text(
                'shift_post_details'.tr(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // UNIT  (shows siteName + unitCode like llUnitSelected)
          _fieldTitle('unit'.tr()),
          const SizedBox(height: 7),
          _selectionBox(
            text: _unit?.siteName ?? 'CHOOSE UNIT',
            subText: _unit?.unitCode,
            icon: Icons.business_outlined,
            onTap: _pickUnit,
          ),
          const SizedBox(height: 13),

          // SHIFT  (shows shiftName + timing like llShiftSelected)
          _fieldTitle('shift_name'.tr()),
          const SizedBox(height: 7),
          _selectionBox(
            text: _shift?.shiftName ?? 'CHOOSE SHIFT',
            subText: _shift?.displaySubLabel,
            icon: Icons.access_time_outlined,
            onTap: _pickShift,
          ),
          const SizedBox(height: 13),

          // POST
          _fieldTitle('post'.tr()),
          const SizedBox(height: 7),
          _selectionBox(
            text: _post?.postName ?? 'CHOOSE POST',
            icon: Icons.location_on_outlined,
            onTap: _pickPost,
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DUTY TIME CARD
  // =============================================================
  Widget _dutyTimeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time_outlined,
                  size: 19, color: AppColors.textPrimary),
              const SizedBox(width: 8),
              Text(
                'duty_time'.tr(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _dutyTimeRow(
            // NOTE: original used 'duty_out_time_tag' for BOTH rows.
            // Add a 'duty_in_time_tag' key to your translations.
            title: 'duty_in_time_tag'.tr(),
            subtitle: _dutyIn.isEmpty ? '--:--' : _formatTime(_dutyIn),
            color: AppColors.green700,
            background: AppColors.green.withOpacity(0.15),
            onTap: () => _pickTime(isDutyIn: true),
          ),
          const SizedBox(height: 9),
          _dutyTimeRow(
            title: 'duty_out_time_tag'.tr(),
            subtitle: _dutyOut.isEmpty ? '--:--' : _formatTime(_dutyOut),
            color: AppColors.red700,
            background: AppColors.red.withOpacity(0.10),
            onTap: () => _pickTime(isDutyIn: false),
          ),
        ],
      ),
    );
  }

  Widget _dutyTimeRow({
    required String title,
    required String subtitle,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_outlined, size: 25, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.access_time_outlined, size: 28, color: color),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // REASON CARD  (spinnerReason + llOtherRemark)
  // =============================================================
  Widget _reasonCard() {
    final reasons = _api?.data?.reasonList ?? <ReasonModel>[];

    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c),
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined,
                  size: 19, color: AppColors.textPrimary),
              const SizedBox(width: 8),
              Text(
                'reason_for_claim'.tr(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ReasonModel>(
            value: _reason,
            isExpanded: true,
            icon:
                Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
            decoration: InputDecoration(
              hintText: 'Choose reason',
              hintStyle:
                  TextStyle(fontSize: 11, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.background,
              prefixIcon: Icon(Icons.description_outlined,
                  color: AppColors.textPrimary, size: 21),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: border(AppColors.border),
              enabledBorder: border(AppColors.border),
              focusedBorder: border(AppColors.red),
            ),
            items: reasons
                .map((r) => DropdownMenuItem<ReasonModel>(
                      value: r,
                      child:
                          Text(r.reason, style: const TextStyle(fontSize: 12)),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _reason = v),
          ),

          // llOtherRemark – only when reason == "Other"
          if (_reason?.isOther ?? false) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _remarkCtrl,
              maxLines: 3,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Enter remark',
                hintStyle:
                    TextStyle(fontSize: 11, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.background,
                border: border(AppColors.border),
                enabledBorder: border(AppColors.border),
                focusedBorder: border(AppColors.red),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =============================================================
  // SUBMIT BUTTON
  // =============================================================
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _submitting ? null : _onSubmit,
        icon: _submitting
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.white),
              )
            : Icon(Icons.send_outlined, size: 20, color: AppColors.white),
        label: Text(
          _submitting ? 'Please wait...' : 'submit_missing_claim'.tr(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // SMALL HELPERS
  // =============================================================
  Widget _fieldTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _selectionBox({
    required String text,
    String? subText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.textPrimary, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 23, color: AppColors.textPrimary),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subText != null && subText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 23),
          ],
        ),
      ),
    );
  }
}
