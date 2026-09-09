class ConvertedLeadModel {
  int yourLoans;
  int amountDisbursed;
  List<Loans> loans;

  ConvertedLeadModel({
    required this.yourLoans,
    required this.amountDisbursed,
    required this.loans,
  });

  factory ConvertedLeadModel.fromJson(Map<String, dynamic> json) {
    return ConvertedLeadModel(
      yourLoans: json['yourLoans'] ?? 0,
      amountDisbursed: json['amountDisbursed'] ?? 0,
      loans: json['loans'] != null
          ? List<Loans>.from(
        json['loans'].map(
              (v) => Loans.fromJson(v),
        ),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'yourLoans': yourLoans,
      'amountDisbursed': amountDisbursed,
      'loans': loans.map((v) => v.toJson()).toList(),
    };
  }
}

class Loans {
  String loanId;
  String loanStatus;
  String loanStatusText;
  int loanAmount;
  String comment;

  Loans({
    required this.loanId,
    required this.loanStatus,
    required this.loanStatusText,
    required this.loanAmount,
    required this.comment,
  });

  factory Loans.fromJson(Map<String, dynamic> json) {
    return Loans(
      loanId: json['loanId'] ?? '',
      loanStatus: json['loanStatus'] ?? '',
      loanStatusText: json['loanStatusText'] ?? '',
      loanAmount: json['loanAmount'] ?? 0,
      comment: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loanId': loanId,
      'loanStatus': loanStatus,
      'loanStatusText': loanStatusText,
      'loanAmount': loanAmount,
      'comment': comment,
    };
  }
}