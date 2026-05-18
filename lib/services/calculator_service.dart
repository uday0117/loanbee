import 'dart:math';

import 'package:loanbee/models/calculator_models.dart';

class CalculatorService {
  // EMI Calculator
  static EMIResult calculateEMI({
    required double principal,
    required double rateOfInterest,
    required int tenure,
  }) {
    double monthlyRate = rateOfInterest / 12 / 100;
    int months = tenure * 12;

    double emi =
        (principal * monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    double totalPayment = emi * months;
    double totalInterest = totalPayment - principal;

    return EMIResult(
      emi: emi,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
      principalAmount: principal,
    );
  }

  // Loan Eligibility Calculator
  static LoanEligibilityResult calculateLoanEligibility({
    required double monthlyIncome,
    required double existingEMI,
    required double rateOfInterest,
    required int tenure,
    required double foirPercentage,
  }) {
    double availableIncome =
        monthlyIncome * (foirPercentage / 100) - existingEMI;

    if (availableIncome <= 0) {
      return LoanEligibilityResult(
        eligibleLoanAmount: 0,
        emi: 0,
        isEligible: false,
        message: 'Your existing EMI exceeds the allowed FOIR limit',
      );
    }

    double monthlyRate = rateOfInterest / 12 / 100;
    int months = tenure * 12;

    double eligibleLoan =
        (availableIncome * (pow(1 + monthlyRate, months) - 1)) /
        (monthlyRate * pow(1 + monthlyRate, months));

    return LoanEligibilityResult(
      eligibleLoanAmount: eligibleLoan,
      emi: availableIncome,
      isEligible: true,
      message: 'You are eligible for this loan amount',
    );
  }

  // SIP Calculator
  static SIPResult calculateSIP({
    required double monthlyInvestment,
    required double expectedReturn,
    required int tenure,
  }) {
    double monthlyRate = expectedReturn / 12 / 100;
    int months = tenure * 12;

    double futureValue =
        monthlyInvestment *
        ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
        (1 + monthlyRate);

    double investedAmount = monthlyInvestment * months;
    double estimatedReturns = futureValue - investedAmount;

    return SIPResult(
      investedAmount: investedAmount,
      estimatedReturns: estimatedReturns,
      totalValue: futureValue,
    );
  }

  // FD/RD Calculator
  static FDResult calculateFD({
    required double principal,
    required double rateOfInterest,
    required int tenure,
    required int compoundingFrequency,
  }) {
    double rate = rateOfInterest / 100;
    double time = tenure / 12;

    double maturityAmount =
        principal *
        pow(1 + (rate / compoundingFrequency), compoundingFrequency * time);

    double totalInterest = maturityAmount - principal;

    return FDResult(
      maturityAmount: maturityAmount,
      totalInterest: totalInterest,
      principalAmount: principal,
    );
  }

  static FDResult calculateRD({
    required double monthlyDeposit,
    required double rateOfInterest,
    required int tenure,
  }) {
    double monthlyRate = rateOfInterest / 12 / 100;
    int months = tenure;

    double maturityAmount =
        monthlyDeposit *
        ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
        (1 + monthlyRate);

    double investedAmount = monthlyDeposit * months;
    double totalInterest = maturityAmount - investedAmount;

    return FDResult(
      maturityAmount: maturityAmount,
      totalInterest: totalInterest,
      principalAmount: investedAmount,
    );
  }

  // GST Calculator
  static GSTResult calculateGST({
    required double amount,
    required double gstRate,
    required bool includesGST,
  }) {
    double gstAmount;
    double originalAmount;
    double totalAmount;

    if (includesGST) {
      totalAmount = amount;
      originalAmount = amount / (1 + (gstRate / 100));
      gstAmount = amount - originalAmount;
    } else {
      originalAmount = amount;
      gstAmount = amount * (gstRate / 100);
      totalAmount = amount + gstAmount;
    }

    double cgst = gstAmount / 2;
    double sgst = gstAmount / 2;

    return GSTResult(
      originalAmount: originalAmount,
      gstAmount: gstAmount,
      totalAmount: totalAmount,
      cgst: cgst,
      sgst: sgst,
    );
  }

  // Amortization Schedule
  static List<AmortizationScheduleEntry> generateAmortizationSchedule({
    required double principal,
    required double rateOfInterest,
    required int tenure,
  }) {
    double monthlyRate = rateOfInterest / 12 / 100;
    int months = tenure * 12;

    double emi =
        (principal * monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    List<AmortizationScheduleEntry> schedule = [];
    double balance = principal;

    for (int i = 1; i <= months; i++) {
      double interest = balance * monthlyRate;
      double principalPaid = emi - interest;
      balance -= principalPaid;

      if (balance < 0) balance = 0;

      schedule.add(
        AmortizationScheduleEntry(
          month: i,
          emi: emi,
          principal: principalPaid,
          interest: interest,
          balance: balance,
        ),
      );
    }

    return schedule;
  }
}
