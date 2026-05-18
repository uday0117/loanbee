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

    // Calculator data with colors
    final calculators = [
      {
        'icon': Icons.calculate_rounded,
        'title': 'EMI Calculator',
        'subtitle': 'Calculate monthly loan payments',
        'screen': const EMICalculatorScreen(),
        'startColor': const Color(0xFFFF8C42),
        'endColor': const Color(0xFFFFAA6B),
      },
      {
        'icon': Icons.check_circle_outline_rounded,
        'title': 'Loan Eligibility',
        'subtitle': 'Check your loan eligibility',
        'screen': const LoanEligibilityScreen(),
        'startColor': const Color(0xFF4CAF50),
        'endColor': const Color(0xFF66BB6A),
      },
      {
        'icon': Icons.trending_up_rounded,
        'title': 'SIP Calculator',
        'subtitle': 'Plan your mutual fund investments',
        'screen': const SIPCalculatorScreen(),
        'startColor': const Color(0xFF2196F3),
        'endColor': const Color(0xFF42A5F5),
      },
      {
        'icon': Icons.account_balance_rounded,
        'title': 'FD/RD Calculator',
        'subtitle': 'Calculate fixed deposit returns',
        'screen': const FDRDCalculatorScreen(),
        'startColor': const Color(0xFF9C27B0),
        'endColor': const Color(0xFFAB47BC),
      },
      {
        'icon': Icons.receipt_long_rounded,
        'title': 'GST Calculator',
        'subtitle': 'Calculate GST and taxes',
        'screen': const GSTCalculatorScreen(),
        'startColor': const Color(0xFFF44336),
        'endColor': const Color(0xFFE57373),
      },
      {
        'icon': Icons.currency_exchange_rounded,
        'title': 'Currency Converter',
        'subtitle': 'Convert between currencies',
        'screen': const CurrencyConverterScreen(),
        'startColor': const Color(0xFF009688),
        'endColor': const Color(0xFF26A69A),
      },
      {
        'icon': Icons.table_chart_rounded,
        'title': 'Amortization Schedule',
        'subtitle': 'View detailed payment schedule',
        'screen': const AmortizationScreen(),
        'startColor': const Color(0xFF3F51B5),
        'endColor': const Color(0xFF5C6BC0),
      },
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern SliverAppBar with gradient
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppTheme.darkGradient
                      : AppTheme.primaryGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
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
                                height: 36,
                                width: 36,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'LoanBee',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Financial Calculator Suite',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    themeController.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                  color: Colors.white,
                  onPressed: () => themeController.toggleTheme(),
                  tooltip: 'Toggle theme',
                ),
              ),
            ],
          ),

          // Calculator Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                'Choose a Calculator',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final calc = calculators[index];
                return FeatureCard(
                  icon: calc['icon'] as IconData,
                  title: calc['title'] as String,
                  subtitle: calc['subtitle'] as String,
                  gradientStartColor: calc['startColor'] as Color,
                  gradientEndColor: calc['endColor'] as Color,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(SlidePageRoute(page: calc['screen'] as Widget));
                  },
                );
              }, childCount: calculators.length),
            ),
          ),

          // Footer spacing
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
