import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loanbee/models/calculator_models.dart';
import 'package:loanbee/services/calculator_service.dart';
import 'package:loanbee/themes/app_theme.dart';
import 'package:loanbee/widgets/common_widgets.dart';

class FDRDCalculatorScreen extends StatefulWidget {
  const FDRDCalculatorScreen({super.key});

  @override
  State<FDRDCalculatorScreen> createState() => _FDRDCalculatorScreenState();
}

class _FDRDCalculatorScreenState extends State<FDRDCalculatorScreen> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _monthlyController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();

  bool _isFD = true;
  int _compoundingFrequency = 4; // Quarterly
  FDResult? _result;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 0,
  );

  void _calculate() {
    if (_isFD) {
      if (_principalController.text.isEmpty ||
          _rateController.text.isEmpty ||
          _tenureController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
        return;
      }

      setState(() {
        _result = CalculatorService.calculateFD(
          principal: double.parse(_principalController.text),
          rateOfInterest: double.parse(_rateController.text),
          tenure: int.parse(_tenureController.text),
          compoundingFrequency: _compoundingFrequency,
        );
      });
    } else {
      if (_monthlyController.text.isEmpty ||
          _rateController.text.isEmpty ||
          _tenureController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
        return;
      }

      setState(() {
        _result = CalculatorService.calculateRD(
          monthlyDeposit: double.parse(_monthlyController.text),
          rateOfInterest: double.parse(_rateController.text),
          tenure: int.parse(_tenureController.text),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FD/RD Calculator')),
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
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: true,
                          label: Text('FD'),
                          icon: Icon(Icons.account_balance),
                        ),
                        ButtonSegment(
                          value: false,
                          label: Text('RD'),
                          icon: Icon(Icons.calendar_month),
                        ),
                      ],
                      selected: {_isFD},
                      onSelectionChanged: (Set<bool> selection) {
                        setState(() {
                          _isFD = selection.first;
                          _result = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_isFD) ...[
                      InputField(
                        label: 'Principal Amount',
                        suffix: '₹',
                        controller: _principalController,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        initialValue: _compoundingFrequency,
                        decoration: const InputDecoration(
                          labelText: 'Compounding Frequency',
                        ),
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Annually')),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Half-Yearly'),
                          ),
                          DropdownMenuItem(value: 4, child: Text('Quarterly')),
                          DropdownMenuItem(value: 12, child: Text('Monthly')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _compoundingFrequency = value!;
                          });
                        },
                      ),
                    ] else ...[
                      InputField(
                        label: 'Monthly Deposit',
                        suffix: '₹',
                        controller: _monthlyController,
                      ),
                    ],
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Interest Rate',
                      suffix: '%',
                      controller: _rateController,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: _isFD ? 'Tenure (months)' : 'Tenure (months)',
                      controller: _tenureController,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _calculate,
                      child: Text('Calculate ${_isFD ? 'FD' : 'RD'}'),
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              ResultCard(
                title: 'Maturity Amount',
                value: _currencyFormat.format(_result!.maturityAmount),
                icon: Icons.account_balance_wallet,
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 8),
              ResultCard(
                title: 'Total Interest',
                value: _currencyFormat.format(_result!.totalInterest),
                icon: Icons.trending_up,
                backgroundColor: Colors.blue,
              ),
              const SizedBox(height: 8),
              ResultCard(
                title: _isFD ? 'Principal Amount' : 'Total Invested',
                value: _currencyFormat.format(_result!.principalAmount),
                icon: Icons.savings,
                backgroundColor: AppTheme.primaryOrange,
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
    _monthlyController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }
}
