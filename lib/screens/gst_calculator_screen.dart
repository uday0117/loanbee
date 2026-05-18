import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loanbee/models/calculator_models.dart';
import 'package:loanbee/services/calculator_service.dart';
import 'package:loanbee/themes/app_theme.dart';
import 'package:loanbee/widgets/common_widgets.dart';

class GSTCalculatorScreen extends StatefulWidget {
  const GSTCalculatorScreen({super.key});

  @override
  State<GSTCalculatorScreen> createState() => _GSTCalculatorScreenState();
}

class _GSTCalculatorScreenState extends State<GSTCalculatorScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _gstRateController = TextEditingController(
    text: '18',
  );

  bool _includesGST = false;
  GSTResult? _result;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 2,
  );

  void _calculateGST() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter amount')));
      return;
    }

    setState(() {
      _result = CalculatorService.calculateGST(
        amount: double.parse(_amountController.text),
        gstRate: double.parse(_gstRateController.text),
        includesGST: _includesGST,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GST Calculator')),
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
                      label: 'Amount',
                      suffix: '₹',
                      controller: _amountController,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            label: 'GST Rate',
                            suffix: '%',
                            controller: _gstRateController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<double>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            _gstRateController.text = value.toString();
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 5, child: Text('5%')),
                            const PopupMenuItem(value: 12, child: Text('12%')),
                            const PopupMenuItem(value: 18, child: Text('18%')),
                            const PopupMenuItem(value: 28, child: Text('28%')),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Amount includes GST'),
                      value: _includesGST,
                      onChanged: (value) {
                        setState(() {
                          _includesGST = value;
                          _result = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calculateGST,
                      child: const Text('Calculate GST'),
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              ResultCard(
                title: 'Original Amount',
                value: _currencyFormat.format(_result!.originalAmount),
                icon: Icons.receipt_long,
                backgroundColor: Colors.blue,
              ),
              const SizedBox(height: 8),
              ResultCard(
                title: 'GST Amount',
                value: _currencyFormat.format(_result!.gstAmount),
                icon: Icons.payments,
                backgroundColor: AppTheme.primaryOrange,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'CGST',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currencyFormat.format(_result!.cgst),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'SGST',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currencyFormat.format(_result!.sgst),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ResultCard(
                title: 'Total Amount',
                value: _currencyFormat.format(_result!.totalAmount),
                icon: Icons.account_balance_wallet,
                backgroundColor: Colors.green,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _gstRateController.dispose();
    super.dispose();
  }
}
