// Dart models for the Missing Claim API response.
// Real JSON keys: Unit[UNIT_CODE, SITE_NAME], Shift[UNIT_CODE, SHIFT_ID, SHIFT_NAME,
// START_TIME, END_TIME], Post[UNIT_CODE, POST_ID, POST_NAME], Reason[Reason_Id, Reason]

String _norm(String s) => s.replaceAll('_', '').toLowerCase();

/// Case-insensitive, underscore-insensitive lookup:
/// 'UNIT_CODE', 'unitCode', 'unit_code', 'UnitCode' all match the key 'unitcode'.
String _pick(Map<String, dynamic> j, List<String> keys) {
  final wanted = keys.map(_norm).toSet();
  for (final entry in j.entries) {
    if (wanted.contains(_norm(entry.key)) && entry.value != null) {
      return entry.value.toString().trim();
    }
  }
  return '';
}

abstract class SelectableItem {
  String get displayName;
  String get displaySubLabel;
}

class UnitModel implements SelectableItem {
  final String unitCode;
  final String siteName;

  UnitModel({required this.unitCode, required this.siteName});

  factory UnitModel.fromJson(Map<String, dynamic> j) => UnitModel(
    unitCode: _pick(j, ['UNIT_CODE']),
    siteName: _pick(j, ['SITE_NAME']),
  );

  @override
  String get displayName => siteName;

  @override
  String get displaySubLabel => unitCode;
}

class ShiftModel implements SelectableItem {
  final String shiftId;
  final String unitCode;
  final String shiftName;
  final String startTime;
  final String endTime;

  ShiftModel({
    required this.shiftId,
    required this.unitCode,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> j) => ShiftModel(
    shiftId: _pick(j, ['SHIFT_ID']),
    unitCode: _pick(j, ['UNIT_CODE']),
    shiftName: _pick(j, ['SHIFT_NAME']),
    startTime: _pick(j, ['START_TIME']),
    endTime: _pick(j, ['END_TIME']),
  );

  String _hm(String t) => t.length >= 5 ? t.substring(0, 5) : t;

  @override
  String get displayName => shiftName;

  @override
  String get displaySubLabel => '${_hm(startTime)} - ${_hm(endTime)}';
}

class PostModel implements SelectableItem {
  final String postId;
  final String postName;
  final String unitCode;

  PostModel({required this.postId, required this.postName, required this.unitCode});

  factory PostModel.fromJson(Map<String, dynamic> j) => PostModel(
    postId: _pick(j, ['POST_ID']),
    unitCode: _pick(j, ['UNIT_CODE']),
    postName: _pick(j, ['POST_NAME']),
  );

  @override
  String get displayName => postName;

  @override
  String get displaySubLabel => '';
}

class ReasonModel {
  final String reasonId;
  final String reason;

  ReasonModel({required this.reasonId, required this.reason});

  factory ReasonModel.fromJson(Map<String, dynamic> j) => ReasonModel(
    reasonId: _pick(j, ['Reason_Id']),
    reason: _pick(j, ['Reason']),
  );

  bool get isOther => reason.toLowerCase() == 'other';

  @override
  String toString() => reason;
}

class MissingDataModel {
  final List<UnitModel> unitList;
  final List<ShiftModel> shiftList;
  final List<PostModel> postList;
  final List<ReasonModel> reasonList;

  MissingDataModel({
    required this.unitList,
    required this.shiftList,
    required this.postList,
    required this.reasonList,
  });

  static List<T> _list<T>(dynamic raw, T Function(Map<String, dynamic>) f) {
    if (raw is! List) return <T>[];
    return raw.whereType<Map>().map((e) => f(Map<String, dynamic>.from(e))).toList();
  }

  factory MissingDataModel.fromJson(Map<String, dynamic> j) => MissingDataModel(
    unitList: _list(j['Unit'], UnitModel.fromJson),
    shiftList: _list(j['Shift'], ShiftModel.fromJson),
    postList: _list(j['Post'], PostModel.fromJson),
    reasonList: _list(j['Reason'], ReasonModel.fromJson),
  );

  // ---- filters by unit code (trim-safe comparison) ----
  List<ShiftModel> shiftsForUnit(String unitCode) =>
      shiftList.where((s) => s.unitCode == unitCode.trim()).toList();

  List<PostModel> postsForUnit(String unitCode) {
    final seen = <String>{}; // API sends duplicate rows
    return postList
        .where((p) => p.unitCode == unitCode.trim() && seen.add('${p.postId}|${p.postName}'))
        .toList();
  }
}

class MissingClaimApiResponse {
  final MissingDataModel? data;
  final String status;
  final String? error;

  MissingClaimApiResponse({this.data, required this.status, this.error});

  bool get isSuccess => status.toLowerCase() == 'true';

  factory MissingClaimApiResponse.fromJson(Map<String, dynamic> j) {
    final d = j['data'];
    return MissingClaimApiResponse(
      data: d is Map ? MissingDataModel.fromJson(Map<String, dynamic>.from(d)) : null,
      status: (j['status'] ?? '').toString(),
      error: j['error']?.toString(),
    );
  }
}