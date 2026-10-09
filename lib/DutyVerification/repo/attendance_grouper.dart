import '../models/attendance_day.dart';
import '../models/attendance_record.dart';
import '../models/attendance_status.dart';

/// Port of AttendanceGrouper.java
/// Collapses flat shift rows into one AttendanceDay per calendar date.
class AttendanceGrouper {
  AttendanceGrouper._();

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December'
  ];
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static List<AttendanceDay> groupByDate(
      List<AttendanceRecord> records,
      String startDate,
      String endDate,
      ) {
    final byDate = <String, List<AttendanceRecord>>{};
    for (final r in records) {
      final key = r.dateKey;
      if (key.isEmpty) continue;
      byDate.putIfAbsent(key, () => []).add(r);
    }

    // Full range from dateRange, not from byDate.keys
    final keys = _buildDateRange(startDate, endDate);
    return keys.map((k) => _buildDay(k, byDate[k])).toList();
  }

  static List<String> _buildDateRange(String start, String end) {
    try {
      if (start.length < 10 || end.length < 10) return [];
      final s = DateTime.parse(start.substring(0, 10));
      final e = DateTime.parse(end.substring(0, 10));
      final keys = <String>[];
      // DateTime(y, m, d + 1) is DST-safe
      for (var d = s; !d.isAfter(e); d = DateTime(d.year, d.month, d.day + 1)) {
        keys.add(_key(d));
      }
      return keys;
    } catch (_) {
      return [];
    }
  }

  static String _key(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

  static AttendanceDay _buildDay(String dateKey, List<AttendanceRecord>? shifts) {
    final day = AttendanceDay()..dateKey = dateKey;

    try {
      final d = DateTime.parse(dateKey);
      day.dateLabel = '${d.day} ${_months[d.month - 1]}';
      day.dayName = _days[d.weekday - 1];
    } catch (_) {
      day.dateLabel = dateKey;
      day.dayName = '';
    }

    // No shift rows -> missing/pending day
    if (shifts == null || shifts.isEmpty) return day;

    day.shiftCount = shifts.length;
    day.unitCode = shifts.first.unitCode;

    double totalCount = 0.0;
    int totalMin = 0;
    bool anyMissing = false;
    for (final r in shifts) {
      totalCount += r.dutyCount ?? 0.0;
      if (r.dutyMin == null) {
        anyMissing = true;
      } else {
        totalMin += r.dutyMin!;
      }
    }
    day.totalDutyCount = totalCount;
    day.totalDutyMin = totalMin;
    day.anyMissingHours = anyMissing;

    // All approved -> Approved, any rejected -> Rejected, else Pending
    final approved =
        shifts.where((r) => r.status == AttendanceStatus.approved).length;
    final rejected =
        shifts.where((r) => r.status == AttendanceStatus.rejected).length;
    day.status = approved == shifts.length
        ? AttendanceStatus.approved
        : (rejected > 0 ? AttendanceStatus.rejected : AttendanceStatus.pending);

    day.claimPending = shifts.any((r) => r.claimPending);

    // Collapse shift names: "B-SHIFT ×3"
    final counts = <String, int>{};
    for (final r in shifts) {
      final name = (r.shiftName != null && r.shiftName!.isNotEmpty)
          ? r.shiftName!
          : '\u2014';
      counts[name] = (counts[name] ?? 0) + 1;
    }
    day.shiftLabels = counts.entries
        .map((e) => e.value > 1 ? '${e.key} \u00d7${e.value}' : e.key)
        .toList();

    return day;
  }

  static int countConfirmed(List<AttendanceDay> days) =>
      days.where((d) => d.status == AttendanceStatus.approved).length;

  static int countRejected(List<AttendanceDay> days) =>
      days.where((d) => d.status == AttendanceStatus.rejected).length;

  static int countClaimPending(List<AttendanceDay> days) =>
      days.where((d) => d.claimPending).length;
}