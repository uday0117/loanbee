import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loanbee/models/calculator_models.dart';
import 'package:loanbee/services/calculator_service.dart';
import 'package:loanbee/widgets/common_widgets.dart';

class AmortizationScreen extends StatefulWidget {
  const AmortizationScreen({super.key});

  @override
  State<AmortizationScreen> createState() => _AmortizationScreenState();
}

class _AmortizationScreenState extends State<AmortizationScreen> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();

  List<AmortizationScheduleEntry>? _schedule;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 0,
  );

  void _generateSchedule() {
    if (_principalController.text.isEmpty ||
        _rateController.text.isEmpty ||
        _tenureController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() {
      _schedule = CalculatorService.generateAmortizationSchedule(
        principal: double.parse(_principalController.text),
        rateOfInterest: double.parse(_rateController.text),
        tenure: int.parse(_tenureController.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Amortization Schedule')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
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
                    onPressed: _generateSchedule,
                    child: const Text('Generate Schedule'),
                  ),
                ],
              ),
            ),
          ),
          if (_schedule != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_schedule!.length} Payments',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filter'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _schedule!.length,
                itemBuilder: (context, index) {
                  final entry = _schedule![index];
                  final isYearEnd = entry.month % 12 == 0;

                  return Card(
                    color: isYearEnd ? Colors.orange.shade50 : null,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ExpansionTile(
                      title: Text(
                        'Month ${entry.month}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'EMI: ${_currencyFormat.format(entry.emi)}',
                      ),
                      trailing: Text(
                        'Balance: ${_currencyFormat.format(entry.balance)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                'Principal Payment',
                                _currencyFormat.format(entry.principal),
                                Colors.blue,
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                'Interest Payment',
                                _currencyFormat.format(entry.interest),
                                Colors.red,
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                'Total EMI',
                                _currencyFormat.format(entry.emi),
                                Colors.orange,
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                'Remaining Balance',
                                _currencyFormat.format(entry.balance),
                                Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
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
