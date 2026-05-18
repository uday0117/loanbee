import 'dart:convert';

import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';

  static Future<Map<String, double>> getExchangeRates(
    String baseCurrency,
  ) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$baseCurrency'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        return rates.map((key, value) => MapEntry(key, value.toDouble()));
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      // Return default rates if API fails
      return _getDefaultRates();
    }
  }

  static Map<String, double> _getDefaultRates() {
    return {
      'USD': 1.0,
      'EUR': 0.85,
      'GBP': 0.73,
      'INR': 83.12,
      'JPY': 110.0,
      'AUD': 1.35,
      'CAD': 1.25,
      'CHF': 0.92,
      'CNY': 6.45,
      'AED': 3.67,
    };
  }

  static double convertCurrency(double amount, double fromRate, double toRate) {
    return (amount / fromRate) * toRate;
  }
}
