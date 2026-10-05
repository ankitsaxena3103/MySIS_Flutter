/*
 * Created by Ankit Saxena on 02-10-2026.
 */

class WalletResponse {
  final double fund;
  final double withdrawable;
  final double total;
  final String currency;
  final double totalPaid;
  final double rfdMonthToDate;

  WalletResponse({
    required this.fund,
    required this.withdrawable,
    required this.total,
    required this.currency,
    required this.totalPaid,
    required this.rfdMonthToDate,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      fund: double.tryParse('${json['fund'] ?? 0}') ?? 0,
      withdrawable:
      double.tryParse('${json['withdrawable'] ?? 0}') ?? 0,
      total: double.tryParse('${json['total'] ?? 0}') ?? 0,
      currency: json['currency']?.toString() ?? 'INR',
      totalPaid:
      double.tryParse('${json['total_paid'] ?? 0}') ?? 0,
      rfdMonthToDate:
      double.tryParse('${json['rfd_month_to_date'] ?? 0}') ?? 0,
    );
  }
}
