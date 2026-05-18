import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loanbee/models/calculator_models.dart';
import 'package:loanbee/services/calculator_service.dart';
import 'package:loanbee/themes/app_theme.dart';
import 'package:loanbee/widgets/common_widgets.dart';

class EMICalculatorScreen extends StatefulWidget {
  const EMICalculatorScreen({super.key});

  @override
  State<EMICalculatorScreen> createState() => _EMICalculatorScreenState();
}

class _EMICalculatorScreenState extends State<EMICalculatorScreen> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();

  EMIResult? _result;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 0,
  );

  void _calculateEMI() {
    if (_principalController.text.isEmpty ||
        _rateController.text.isEmpty ||
        _tenureController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() {
      _result = CalculatorService.calculateEMI(
        principal: double.parse(_principalController.text),
        rateOfInterest: double.parse(_rateController.text),
        tenure: int.parse(_tenureController.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMI Calculator')),
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
                      label: 'Loan Amount',
                      suffix: '₹',
                      controller: _principalController,
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
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _calculateEMI,
                      child: const Text('Calculate EMI'),
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              ResultCard(
                title: 'Monthly EMI',
                value: _currencyFormat.format(_result!.emi),
                icon: Icons.calendar_month,
                backgroundColor: AppTheme.primaryOrange,
              ),
              const SizedBox(height: 8),
              ResultCard(
                title: 'Total Payment',
                value: _currencyFormat.format(_result!.totalPayment),
                icon: Icons.payment,
                backgroundColor: Colors.blue,
              ),
              const SizedBox(height: 8),
              ResultCard(
                title: 'Total Interest',
                value: _currencyFormat.format(_result!.totalInterest),
                icon: Icons.trending_up,
                backgroundColor: Colors.red.shade700,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Breakdown',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: _result!.principalAmount,
                                title:
                                    'Principal\n${(_result!.principalAmount / _result!.totalPayment * 100).toStringAsFixed(1)}%',
                                color: Colors.green,
                                radius: 100,
                              ),
                              PieChartSectionData(
                                value: _result!.totalInterest,
                                title:
                                    'Interest\n${(_result!.totalInterest / _result!.totalPayment * 100).toStringAsFixed(1)}%',
                                color: Colors.red,
                                radius: 100,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }
}
