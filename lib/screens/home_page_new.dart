import 'package:flutter/material.dart';
import 'package:loanbee/controllers/theme_controller.dart';
import 'package:loanbee/screens/amortization_screen.dart';
import 'package:loanbee/screens/currency_converter_screen.dart';
import 'package:loanbee/screens/emi_calculator_screen.dart';
import 'package:loanbee/screens/fd_rd_calculator_screen.dart';
import 'package:loanbee/screens/gst_calculator_screen.dart';
import 'package:loanbee/screens/loan_eligibility_screen.dart';
import 'package:loanbee/screens/sip_calculator_screen.dart';
import 'package:loanbee/themes/app_theme.dart';
import 'package:loanbee/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkGradient : AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/icons/app-icon.png',
                            height: 40,
                            width: 40,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'LoanBee',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          themeController.isDarkMode
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => themeController.toggleTheme(),
                      ),
                    ),
                  ],
                ),
              ),

              // Welcome Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Financial Calculators',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose a calculator below',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Calculator Grid
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: GridView.count(
                    padding: const EdgeInsets.all(20),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      _CalculatorTile(
                        icon: Icons.calculate_rounded,
                        title: 'EMI Calculator',
                        subtitle: 'Monthly loan payments',
                        color: const Color(0xFFFF8C42),
                        onTap: () => Navigator.of(context).push(
                          SlidePageRoute(page: const EMICalculatorScreen()),
                        ),
                      ),
                      _CalculatorTile(
                        icon: Icons.check_circle_outline_rounded,
                        title: 'Loan Eligibility',
                        subtitle: 'Check eligibility',
                        color: const Color(0xFF4CAF50),
                        onTap: () => Navigator.of(context).push(
                          SlidePageRoute(page: const LoanEligibilityScreen()),
                        ),
                      ),
                      _CalculatorTile(
                        icon: Icons.trending_up_rounded,
                        title: 'SIP Calculator',
                        subtitle: 'Mutual fund plans',
                        color: const Color(0xFF2196F3),
                        onTap: () => Navigator.of(context).push(
                          SlidePageRoute(page: const SIPCalculatorScreen()),
                        ),
                      ),
                      _CalculatorTile(
                        icon: Icons.account_balance_rounded,
                        title: 'FD/RD Calculator',
                        subtitle: 'Fixed deposits',
                        color: const Color(0xFF9C27B0),
                        onTap: () => Navigator.of(context).push(
                          SlidePageRoute(page: const FDRDCalculatorScreen()),
                        ),
                      ),
                      _CalculatorTile(
                        icon: Icons.receipt_long_rounded,
                        title: 'GST Calculator',
                        subtitle: 'Tax calculations',
                        color: const Color(0xFFF44336),
                        onTap: () => Navigator.of(context).push(
                          SlidePageRoute(page: const GSTCalculatorScreen()),
                        ),
                      ),
                      _CalculatorTile(
                        icon: Icons.currency_exchange_rounded,
                        title: 'Currency Converter',
                        subtitle: 'Exchange rates',
                        color: const Color(0xFF009688),
                        onTap: () => Navigator.of(context).push(
                          SlidePageRoute(page: const CurrencyConverterScreen()),
                        ),
                      ),
                      _CalculatorTile(
                        icon: Icons.table_chart_rounded,
                        title: 'Amortization',
                        subtitle: 'Payment schedule',
                        color: const Color(0xFF3F51B5),
                        onTap: () => Navigator.of(context).push(
                          SlidePageRoute(page: const AmortizationScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalculatorTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CalculatorTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
