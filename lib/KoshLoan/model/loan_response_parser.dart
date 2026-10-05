// loan_response_parser.dart
//
// Dart port of the Java Gson model LoanResponseParser. Field names match
// your actual API response exactly:
//
// {
//   "count": 0,
//   "phase": "pre_approval",
//   "loan_groups": [],
//   "loan_amount": 0,
//   "disbursed_amount": 0,
//   "approved_loan_amount": 0
// }

import 'dart:convert';

class Loan {
  final String? name;
  final double amount;
  final String? status;
  final int? overdue; // nullable, same as Gson leaving it null

  Loan({this.name, required this.amount, this.status, this.overdue});

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      name: json['name'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String?,
      overdue: json['overdue'] as int?,
    );
  }

  @override
  String toString() =>
      'Loan{name: $name, amount: $amount, status: $status, overdue: $overdue}';
}

class LoanGroup {
  final int id;
  final String? status;
  final bool hold;
  final List<Loan> loans;

  LoanGroup({
    required this.id,
    this.status,
    required this.hold,
    required this.loans,
  });

  factory LoanGroup.fromJson(Map<String, dynamic> json) {
    final loansJson = json['loans'] as List<dynamic>?;
    return LoanGroup(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String?,
      hold: json['hold'] as bool? ?? false,
      // Gson leaves the list null if the key is missing — normalized to [] here.
      loans: loansJson == null
          ? <Loan>[]
          : loansJson.map((e) => Loan.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  String toString() => 'LoanGroup{id: $id, status: $status, hold: $hold, loans: $loans}';
}

class LoanResponse {
  final int count;
  final String? phase;
  final List<LoanGroup> loanGroups;
  final double loanAmount;
  final double disbursedAmount;
  final double approvedLoanAmount;

  LoanResponse({
    required this.count,
    this.phase,
    required this.loanGroups,
    required this.loanAmount,
    required this.disbursedAmount,
    required this.approvedLoanAmount,
  });

  factory LoanResponse.fromJson(Map<String, dynamic> json) {
    final groupsJson = json['loan_groups'] as List<dynamic>?;
    return LoanResponse(
      count: (json['count'] as num?)?.toInt() ?? 0,
      phase: json['phase'] as String?,
      // Normalized to [] if the key is missing, same as the Java parser does.
      loanGroups: groupsJson == null
          ? <LoanGroup>[]
          : groupsJson.map((e) => LoanGroup.fromJson(e as Map<String, dynamic>)).toList(),
      loanAmount: (json['loan_amount'] as num?)?.toDouble() ?? 0,
      disbursedAmount: (json['disbursed_amount'] as num?)?.toDouble() ?? 0,
      approvedLoanAmount: (json['approved_loan_amount'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  String toString() => 'LoanResponse{count: $count, phase: $phase, '
      'loanGroups: $loanGroups, loanAmount: $loanAmount, '
      'disbursedAmount: $disbursedAmount, approvedLoanAmount: $approvedLoanAmount}';
}

class LoanResponseParser {
  /// Parses the raw JSON string into a [LoanResponse].
  /// Returns null on parse failure (mirrors the Java version's
  /// JsonSyntaxException -> null behavior).
  static LoanResponse? parseLoanResponse(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      return LoanResponse.fromJson(decoded);
    } catch (e) {
      // ignore: avoid_print
      print('LoanResponseParser: failed to parse LoanResponse: $e');
      return null;
    }
  }

  /// Convenience method if you only need the loan groups list.
  /// Returns an empty (non-null) list on failure or if the key is absent.
  static List<LoanGroup> parseLoanGroups(String jsonString) {
    final response = parseLoanResponse(jsonString);
    return response != null ? response.loanGroups : <LoanGroup>[];
  }
}