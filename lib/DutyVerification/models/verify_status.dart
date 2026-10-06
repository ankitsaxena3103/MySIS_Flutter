/// One status type for records, day roll-ups and date cards.
/// `absent` is only produced for a date that has no shift rows at all.
enum VerifyStatus {
  pending('Pending'),
  approved('Approved'),
  rejected('Rejected'),
  absent('Absent');

  const VerifyStatus(this.label);
  final String label;

  /// API "STATUS": 0 = pending, 1 = approved, anything else = rejected
  /// (same rule as the Java repository).
  static VerifyStatus fromApi(int apiStatus) {
    if (apiStatus == 0) return VerifyStatus.pending;
    if (apiStatus == 1) return VerifyStatus.approved;
    return VerifyStatus.rejected;
  }
}
