import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loanbee/services/currency_service.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();

  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  double? _convertedAmount;
  Map<String, double> _rates = {};
  bool _isLoading = false;

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'INR',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'AED',
  ];

  final Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'INR': '₹',
    'JPY': '¥',
    'AUD': 'A\$',
    'CAD': 'C\$',
    'CHF': 'Fr',
    'CNY': '¥',
    'AED': 'د.إ',
  };

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    setState(() => _isLoading = true);
    try {
      _rates = await CurrencyService.getExchangeRates(_fromCurrency);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading rates: $e')));
      }
    }
    setState(() => _isLoading = false);
  }

  void _convert() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter amount')));
      return;
    }

    if (_rates.isEmpty) {
      _loadRates();
      return;
    }

    double amount = double.parse(_amountController.text);
    double fromRate = _fromCurrency == 'USD'
        ? 1.0
        : (_rates[_fromCurrency] ?? 1.0);
    double toRate = _rates[_toCurrency] ?? 1.0;

    setState(() {
      _convertedAmount = CurrencyService.convertCurrency(
        amount,
        fromRate,
        toRate,
      );
    });
  }

  void _swapCurrencies() {
    setState(() {
      String temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _convertedAmount = null;
    });
    _loadRates();
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat('#,##0.00');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRates),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              prefixText: _currencySymbols[_fromCurrency],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: _fromCurrency,
                                  decoration: const InputDecoration(
                                    labelText: 'From',
                                  ),
                                  items: _currencies.map((currency) {
                                    return DropdownMenuItem(
                                      value: currency,
                                      child: Text(currency),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _fromCurrency = value!;
                                      _convertedAmount = null;
                                    });
                                    _loadRates();
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.swap_horiz),
                                onPressed: _swapCurrencies,
                              ),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: _toCurrency,
                                  decoration: const InputDecoration(
                                    labelText: 'To',
                                  ),
                                  items: _currencies.map((currency) {
                                    return DropdownMenuItem(
                                      value: currency,
                                      child: Text(currency),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _toCurrency = value!;
                                      _convertedAmount = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _convert,
                            child: const Text('Convert'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_convertedAmount != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'Converted Amount',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_currencySymbols[_toCurrency]} ${formatter.format(_convertedAmount)}',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _toCurrency,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Exchange Rate',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '1 $_fromCurrency = ${formatter.format(_rates[_toCurrency] ?? 0)} $_toCurrency',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
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
    _amountController.dispose();
    super.dispose();
  }
}
