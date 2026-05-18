class EMIResult {
  final double emi;
  final double totalPayment;
  final double totalInterest;
  final double principalAmount;
  
  EMIResult({
    required this.emi,
    required this.totalPayment,
    required this.totalInterest,
    required this.principalAmount,
  });
}

class LoanEligibilityResult {
  final double eligibleLoanAmount;
  final double emi;
  final bool isEligible;
  final String message;
  
  LoanEligibilityResult({
    required this.eligibleLoanAmount,
    required this.emi,
    required this.isEligible,
    required this.message,
  });
}

class SIPResult {
  final double investedAmount;
  final double estimatedReturns;
  final double totalValue;
  
  SIPResult({
    required this.investedAmount,
    required this.estimatedReturns,
    required this.totalValue,
  });
}

class FDResult {
  final double maturityAmount;
  final double totalInterest;
  final double principalAmount;
  
  FDResult({
    required this.maturityAmount,
    required this.totalInterest,
    required this.principalAmount,
  });
}

class GSTResult {
  final double originalAmount;
  final double gstAmount;
  final double totalAmount;
  final double cgst;
  final double sgst;
  
  GSTResult({
    required this.originalAmount,
    required this.gstAmount,
    required this.totalAmount,
    required this.cgst,
    required this.sgst,
  });
}

class AmortizationScheduleEntry {
  final int month;
  final double emi;
  final double principal;
  final double interest;
  final double balance;
  
  AmortizationScheduleEntry({
    required this.month,
    required this.emi,
    required this.principal,
    required this.interest,
    required this.balance,
  });
}
