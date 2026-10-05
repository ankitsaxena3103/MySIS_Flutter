
import 'dart:convert';

class PipelineRecord {
  final int id;
  final String pipelineKey;
  final String stageKey;
  final DateTime? createdAt;
  final DateTime? lastUpdated;
  final String userId;
  final String? recordType;
  final String? source;
  final String? cluster;
  final String? ownerUserId;
  final String? createdByUserId;
  final num? score;
  final DateTime? scoreUpdatedAt;
  final String? cycleStartDate;
  final DateTime? lastSurfacedAt;
  final bool isOpen;
  final DateTime? lastActivityAt;
  final Map<String, dynamic> attributes;
  final int? pipeline;
  final int? currentStage;
  final dynamic recordTypeConfig;

  /// Not part of the original API response — filled in after merging with
  /// the fetchUserMobileNoBaseOnUserID() lookup (keyed by user_id).
  String? mobileNumber;

  PipelineRecord({
    required this.id,
    required this.pipelineKey,
    required this.stageKey,
    this.createdAt,
    this.lastUpdated,
    required this.userId,
    this.recordType,
    this.source,
    this.cluster,
    this.ownerUserId,
    this.createdByUserId,
    this.score,
    this.scoreUpdatedAt,
    this.cycleStartDate,
    this.lastSurfacedAt,
    required this.isOpen,
    this.lastActivityAt,
    Map<String, dynamic>? attributes,
    this.pipeline,
    this.currentStage,
    this.recordTypeConfig,
    this.mobileNumber,
  }) : attributes = attributes ?? const {};

  factory PipelineRecord.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      return DateTime.tryParse(value as String);
    }

    return PipelineRecord(
      id: json['id'] as int,
      pipelineKey: json['pipeline_key'] as String? ?? '',
      stageKey: json['stage_key'] as String? ?? '',
      createdAt: parseDate(json['created_at']),
      lastUpdated: parseDate(json['last_updated']),
      userId: json['user_id'] as String? ?? '',
      recordType: json['record_type'] as String?,
      source: json['source'] as String?,
      cluster: json['cluster'] as String?,
      ownerUserId: json['owner_user_id'] as String?,
      createdByUserId: json['created_by_user_id'] as String?,
      score: json['score'] as num?,
      scoreUpdatedAt: parseDate(json['score_updated_at']),
      cycleStartDate: json['cycle_start_date'] as String?,
      lastSurfacedAt: parseDate(json['last_surfaced_at']),
      isOpen: json['is_open'] as bool? ?? false,
      lastActivityAt: parseDate(json['last_activity_at']),
      attributes: json['attributes'] as Map<String, dynamic>? ?? const {},
      pipeline: json['pipeline'] as int?,
      currentStage: json['current_stage'] as int?,
      recordTypeConfig: json['record_type_config'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pipeline_key': pipelineKey,
      'stage_key': stageKey,
      'created_at': createdAt?.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
      'user_id': userId,
      'record_type': recordType,
      'source': source,
      'cluster': cluster,
      'owner_user_id': ownerUserId,
      'created_by_user_id': createdByUserId,
      'score': score,
      'score_updated_at': scoreUpdatedAt?.toIso8601String(),
      'cycle_start_date': cycleStartDate,
      'last_surfaced_at': lastSurfacedAt?.toIso8601String(),
      'is_open': isOpen,
      'last_activity_at': lastActivityAt?.toIso8601String(),
      'attributes': attributes,
      'pipeline': pipeline,
      'current_stage': currentStage,
      'record_type_config': recordTypeConfig,
      'mobile_number': mobileNumber,
    };
  }

  /// Parses the raw pipeline-records array (firstResponse) into
  /// [PipelineRecord]s, then fills in [mobileNumber] for each record using
  /// the "usernames-by-user-ids" lookup response:
  ///   { "success": true, "data": { "<user_id>": "<mobile_number>", ... } }
  static List<PipelineRecord> buildMergedList(
      List<dynamic> firstResponse,
      String mobileResponseJson,
      ) {
    final records = firstResponse
        .map((e) => PipelineRecord.fromJson(e as Map<String, dynamic>))
        .toList();

    final decoded = jsonDecode(mobileResponseJson) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>? ?? {};

    for (final record in records) {
      record.mobileNumber = data[record.userId] as String?;
    }

    return records;
  }
}
