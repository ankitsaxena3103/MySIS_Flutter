import 'package:easy_localization/easy_localization.dart';

import '../UserRoaster.dart';

class DutyCard {
  // 🟢 Existing Core Fields
  String id;
  String shiftName;
  String shiftId;
  DateTime rosterDate;
  String shiftStartTime;
  String shiftEndTime;
  DateTime dutyStartEnableTime;
  DateTime dutyStartDisableTime;
  DateTime dutyEndDisableTime;
  String? dutyStatus;
  DateTime? actStartTime;
  DateTime? actEndTime;

  String? cardTitle;
  int? dutyInOutButtonShow;
  int? dutyInButtonEnable;
  int? dutyOutButtonEnable;
  String dutyInButtonText;
  String dutyOutButtonText;


  // 🟢 Newly Added (from comment)
  String? siteName;          // roaster.siteName
  String? unitCode;          // roaster.unitCode
  String? postName;          // roaster.postName
  String? qrId;              // roaster.qrId
  String? geoLocation;       // roaster.geoLocation
  bool? isCurrentOrAvailable;

  DutyCard({
    // ✅ Required
    required this.id,
    required this.shiftName,
    required this.shiftId,
    required this.rosterDate,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.dutyStartEnableTime,
    required this.dutyStartDisableTime,
    required this.dutyEndDisableTime,

    // ✅ Optional
    this.dutyStatus,
    this.actStartTime,
    this.actEndTime,
    this.cardTitle,
    this.dutyInOutButtonShow,
    this.dutyInButtonEnable,
    this.dutyOutButtonEnable,
    required this.dutyInButtonText,
    required this.dutyOutButtonText,

    // ✅ Newly added
    this.siteName,
    this.unitCode,
    this.postName,
    this.qrId,
    this.geoLocation,
    this.isCurrentOrAvailable,
  });
}

class ProcessResult {
  final bool isValid;
  final String? error;
  final List<DutyCard> cards;
  ProcessResult(this.isValid, this.error, this.cards);
}

class DutyCardProcessor {
  static ProcessResult process(List<DutyCard>? cards) {
    if (cards == null || cards.isEmpty) {
      return ProcessResult(false, 'No duty cards provided.', <DutyCard>[]);
    }

    final now = DateTime.now();

    // sort by SHIFT_START_TIME
    final sorted = [...cards]..sort((a, b) => a.shiftStartTime.compareTo(b.shiftStartTime));

    // reset UI fields
    for (final c in sorted) {
      c.cardTitle = '';
      c.dutyInOutButtonShow = 0;
      c.dutyInButtonEnable = 0;
      c.dutyOutButtonEnable = 0;
      c.dutyInButtonText = '';
      c.dutyOutButtonText = '';
      c.isCurrentOrAvailable= false;
    }

    // validation: only one active
    final activeCards =
    sorted.where((c) => c.actStartTime != null && c.actEndTime == null).toList();
    if (activeCards.length > 1) {
      return ProcessResult(
          false,
          'Invalid data: More than one active duty without ACT_END_TIME.',
          sorted);
    }

    // 1) Active Duty
    if (activeCards.length == 1) {
      final a = activeCards.first;
      a.cardTitle = 'current_duty_txt'.tr();
      a.dutyInOutButtonShow = 1;
      a.dutyInButtonEnable = 0;
      // a.dutyOutButtonEnable = 1;
      a.dutyOutButtonEnable = (DateTime.now().isAfter(a.dutyStartEnableTime) && DateTime.now().isBefore(a.dutyEndDisableTime)) ? 1 : 0;

      a.dutyInButtonText = '${'duty_in'.tr()} ${fmtTime(a.actStartTime) ?? ''}';
      a.dutyOutButtonText = 'duty_out'.tr();
      a.isCurrentOrAvailable = true;
    }

    // 2) Completed Duty
    for (final c in sorted.where((x) => x.actStartTime != null && x.actEndTime != null)) {
      c.cardTitle =  'completed_duty_txt'.tr();
      c.dutyInOutButtonShow = 1;
      c.dutyInButtonEnable = 0;
      c.dutyOutButtonEnable = 0;
      c.dutyInButtonText = '${'duty_in'.tr()} ${fmtTime(c.actStartTime) ?? ''}';
      c.dutyOutButtonText = '${'duty_out'.tr()} ${fmtTime(c.actEndTime) ?? ''}';
    }

    // 3) Available / Next / Missed (no actuals)
    for (final c in sorted.where((x) => x.actStartTime == null && x.actEndTime == null)) {
      if (!_isAfter(now, c.dutyStartEnableTime) && !_isEqual(now, c.dutyStartEnableTime)) {
        // now < start-enable → Next Duty
        c.cardTitle = 'next_duty_txt'.tr();
        c.dutyInOutButtonShow = 0;
        c.dutyInButtonEnable = 0;
        c.dutyOutButtonEnable = 0;
        c.dutyInButtonText = 'duty_in'.tr();
        c.dutyOutButtonText = 'duty_out'.tr();
      } else if ((_isAfter(now, c.dutyStartEnableTime) || _isEqual(now, c.dutyStartEnableTime)) &&
          (_isBefore(now, c.dutyStartDisableTime) || _isEqual(now, c.dutyStartDisableTime))) {
        // start-enable <= now <= start-disable → Available Duty
        c.cardTitle =  'available_duty_txt'.tr();
        // c.dutyInOutButtonShow = 1;
        c.dutyInButtonEnable = 1;
        c.dutyOutButtonEnable = 0;
        c.dutyInOutButtonShow = activeCards.isNotEmpty ? 0 : 1;

        c.dutyInButtonText = 'duty_in'.tr();
        c.dutyOutButtonText = 'duty_out'.tr();
        c.isCurrentOrAvailable = activeCards.isNotEmpty ? false : true;


      } else if (_isAfter(now, c.dutyStartDisableTime)) {
        // now > start-disable → Missed Duty
        c.cardTitle = 'missed_duty_txt'.tr();
        c.dutyInOutButtonShow = 0;
        c.dutyInButtonEnable = 0;
        c.dutyOutButtonEnable = 0;
        c.dutyInButtonText = 'duty_in'.tr();
        c.dutyOutButtonText = 'duty_out'.tr();
      }
    }

    return ProcessResult(true, null, sorted);
  }

  static String? fmtTime(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('hh:mm a').format(dt).toUpperCase(); // e.g. 07:05 AM
  }

  static bool _isBefore(DateTime a, DateTime b) => a.isBefore(b);
  static bool _isAfter(DateTime a, DateTime b) => a.isAfter(b);
  static bool _isEqual(DateTime a, DateTime b) => a.isAtSameMomentAs(b);
}

class DutyCardMapper {
  static List<DutyCard> fromUserRoaster(List<UserRoaster> roasters) {
    return roasters.map((r) {
      return DutyCard(
        id: r.id,
        shiftName: r.shiftName,
        shiftId: r.shiftId,
        rosterDate: DateTime.parse(r.rosterDate),   // rosterDate is String in your model
        shiftStartTime: r.startTime,
        shiftEndTime: r.endTime ,
        dutyStartEnableTime: r.dutyStartEnableTime ?? DateTime.now(),
        dutyStartDisableTime: r.dutyStartDisableTime ?? DateTime.now(),
        dutyEndDisableTime: r.dutyEndDisableTime ?? DateTime.now(),
        dutyStatus: r.dutyStatus,
        actStartTime: r.actStartTime,
        actEndTime: r.actEndTime,

        // ✅ Newly added fields
        siteName: r.siteName,
        unitCode: r.unitCode,
        postName: r.postName,
        qrId: r.qrId,
        geoLocation: r.geoLocation,
        dutyInButtonText: '',
        dutyOutButtonText: '',

      );

    }).toList();
  }
}
