import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loanbee/models/calculator_models.dart';
import 'package:loanbee/services/calculator_service.dart';
import 'package:loanbee/themes/app_theme.dart';
import 'package:loanbee/widgets/common_widgets.dart';

class SIPCalculatorScreen extends StatefulWidget {
  const SIPCalculatorScreen({super.key});

  @override
  State<SIPCalculatorScreen> createState() => _SIPCalculatorScreenState();
}

class _SIPCalculatorScreenState extends State<SIPCalculatorScreen> {
  final TextEditingController _monthlyController = TextEditingController();
  final TextEditingController _returnController = TextEditingController(
    text: '12',
  );
  final TextEditingController _tenureController = TextEditingController();

  SIPResult? _result;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 0,
  );

  void _calculateSIP() {
    if (_monthlyController.text.isEmpty || _tenureController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() {
      _result = CalculatorService.calculateSIP(
        monthlyInvestment: double.parse(_monthlyController.text),
        expectedReturn: double.parse(_returnController.text),
        tenure: int.parse(_tenureController.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SIP Calculator')),
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
                      label: 'Monthly Investment',
                      suffix: '₹',
                      controller: _monthlyController,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Expected Return Rate',
                      suffix: '%',
                      controller: _returnController,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Investment Period',
                      suffix: 'years',
                      controller: _tenureController,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _calculateSIP,
                      child: const Text('Calculate SIP'),
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              ResultCard(
                title: 'Invested Amount',
                value: _currencyFormat.format(_result!.investedAmount),
                icon: Icons.savings,
                backgroundColor: Colors.blue,
              ),
              const SizedBox(height: 8),
              ResultCard(
                title: 'Estimated Returns',
                value: _currencyFormat.format(_result!.estimatedReturns),
                icon: Icons.trending_up,
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 8),
              ResultCard(
                title: 'Total Value',
                value: _currencyFormat.format(_result!.totalValue),
                icon: Icons.account_balance_wallet,
                backgroundColor: AppTheme.primaryOrange,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Investment Breakdown',
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
                                value: _result!.investedAmount,
                                title:
                                    'Invested\n${(_result!.investedAmount / _result!.totalValue * 100).toStringAsFixed(1)}%',
                                color: Colors.blue,
                                radius: 100,
                              ),
                              PieChartSectionData(
                                value: _result!.estimatedReturns,
                                title:
                                    'Returns\n${(_result!.estimatedReturns / _result!.totalValue * 100).toStringAsFixed(1)}%',
                                color: Colors.green,
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
    _monthlyController.dispose();
    _returnController.dispose();
    _tenureController.dispose();
    super.dispose();
  }
}
