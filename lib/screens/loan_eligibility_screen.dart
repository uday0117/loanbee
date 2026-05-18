import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loanbee/models/calculator_models.dart';
import 'package:loanbee/services/calculator_service.dart';
import 'package:loanbee/themes/app_theme.dart';
import 'package:loanbee/widgets/common_widgets.dart';

class LoanEligibilityScreen extends StatefulWidget {
  const LoanEligibilityScreen({super.key});

  @override
  State<LoanEligibilityScreen> createState() => _LoanEligibilityScreenState();
}

class _LoanEligibilityScreenState extends State<LoanEligibilityScreen> {
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _existingEMIController = TextEditingController();
  final TextEditingController _rateController = TextEditingController(
    text: '8.5',
  );
  final TextEditingController _tenureController = TextEditingController(
    text: '20',
  );
  final TextEditingController _foirController = TextEditingController(
    text: '50',
  );

  LoanEligibilityResult? _result;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 0,
  );

  void _calculateEligibility() {
    if (_incomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your monthly income')),
      );
      return;
    }

    setState(() {
      _result = CalculatorService.calculateLoanEligibility(
        monthlyIncome: double.parse(_incomeController.text),
        existingEMI: double.tryParse(_existingEMIController.text) ?? 0,
        rateOfInterest: double.parse(_rateController.text),
        tenure: int.parse(_tenureController.text),
        foirPercentage: double.parse(_foirController.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Eligibility')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    InputField(
                      label: 'Monthly Income',
                      suffix: '₹',
                      controller: _incomeController,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Existing EMI',
                      suffix: '₹',
                      controller: _existingEMIController,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Interest Rate',
                      suffix: '%',
                      controller: _rateController,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Loan Tenure',
                      suffix: 'years',
                      controller: _tenureController,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'FOIR (Fixed Obligation to Income Ratio)',
                      suffix: '%',
                      controller: _foirController,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _calculateEligibility,
                      child: const Text('Check Eligibility'),
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              Card(
                color: _result!.isEligible ? Colors.green[50] : Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        _result!.isEligible ? Icons.check_circle : Icons.cancel,
                        size: 64,
                        color: _result!.isEligible ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _result!.message,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              if (_result!.isEligible) ...[
                const SizedBox(height: 16),
                ResultCard(
                  title: 'Eligible Loan Amount',
                  value: _currencyFormat.format(_result!.eligibleLoanAmount),
                  icon: Icons.account_balance,
                  backgroundColor: Colors.green,
                ),
                const SizedBox(height: 8),
                ResultCard(
                  title: 'Maximum EMI',
                  value: _currencyFormat.format(_result!.emi),
                  icon: Icons.payment,
                  backgroundColor: AppTheme.primaryOrange,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _existingEMIController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    _foirController.dispose();
    super.dispose();
  }
}
