class walletmodel{
  final int totalEarned;
  final int totalWithdrawn;
  final int withdrawalInProcess;
  final int withdrawalLimit;


  walletmodel({
    required this.totalEarned,
    required this.totalWithdrawn,
    required this.withdrawalInProcess,
    required this.withdrawalLimit,
  });
  factory walletmodel.fromJson(Map<String, dynamic> json) {
  return walletmodel(
  totalEarned: json['totalEarned'] ?? 0,
  totalWithdrawn: json['totalWithdrawn'] ?? 0,
  withdrawalInProcess: json['withdrawalInProcess'] ?? 0,
  withdrawalLimit: json['withdrawalLimit'] ?? 0,
  );
  }
}