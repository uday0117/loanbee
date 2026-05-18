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
import 'package:loanbee/widgets/animated_background.dart';
import 'package:loanbee/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<String> _financialTips = [
    "💡 Start an emergency fund with 3-6 months of expenses",
    "📊 Diversify your investments to minimize risk",
    "💰 Pay off high-interest debt first",
    "🎯 Set clear financial goals and track progress",
    "📈 Invest early to benefit from compound interest",
    "💳 Keep your credit utilization below 30%",
    "🏦 Review your budget regularly",
    "🌟 Save at least 20% of your income",
  ];

  int _currentTipIndex = 0;
  String _searchQuery = '';
  late AnimationController _tipAnimationController;
  late Animation<double> _tipAnimation;

  @override
  void initState() {
    super.initState();
    _tipAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _tipAnimation = CurvedAnimation(
      parent: _tipAnimationController,
      curve: Curves.easeInOut,
    );
    _tipAnimationController.forward();

    // Rotate tips every 5 seconds
    Future.delayed(const Duration(seconds: 5), _rotateTip);
  }

  void _rotateTip() {
    if (!mounted) return;
    _tipAnimationController.reverse().then((_) {
      if (!mounted) return;
      setState(() {
        _currentTipIndex = (_currentTipIndex + 1) % _financialTips.length;
      });
      _tipAnimationController.forward();
      Future.delayed(const Duration(seconds: 5), _rotateTip);
    });
  }

  @override
  void dispose() {
    _tipAnimationController.dispose();
    super.dispose();
  }

  List<_CalculatorItem> get _allCalculators => [
    _CalculatorItem(
      icon: Icons.calculate_rounded,
      title: 'EMI Calculator',
      subtitle: 'Monthly loan payments',
      color: const Color(0xFFFF8C42),
      screen: const EMICalculatorScreen(),
    ),
    _CalculatorItem(
      icon: Icons.check_circle_outline_rounded,
      title: 'Loan Eligibility',
      subtitle: 'Check eligibility',
      color: const Color(0xFF4CAF50),
      screen: const LoanEligibilityScreen(),
    ),
    _CalculatorItem(
      icon: Icons.trending_up_rounded,
      title: 'SIP Calculator',
      subtitle: 'Mutual fund plans',
      color: const Color(0xFF2196F3),
      screen: const SIPCalculatorScreen(),
    ),
    _CalculatorItem(
      icon: Icons.account_balance_rounded,
      title: 'FD/RD Calculator',
      subtitle: 'Fixed deposits',
      color: const Color(0xFF9C27B0),
      screen: const FDRDCalculatorScreen(),
    ),
    _CalculatorItem(
      icon: Icons.receipt_long_rounded,
      title: 'GST Calculator',
      subtitle: 'Tax calculations',
      color: const Color(0xFFF44336),
      screen: const GSTCalculatorScreen(),
    ),
    _CalculatorItem(
      icon: Icons.currency_exchange_rounded,
      title: 'Currency Converter',
      subtitle: 'Exchange rates',
      color: const Color(0xFF009688),
      screen: const CurrencyConverterScreen(),
    ),
    _CalculatorItem(
      icon: Icons.table_chart_rounded,
      title: 'Amortization',
      subtitle: 'Payment schedule',
      color: const Color(0xFF3F51B5),
      screen: const AmortizationScreen(),
    ),
  ];

  List<_CalculatorItem> get _filteredCalculators {
    if (_searchQuery.isEmpty) return _allCalculators;
    return _allCalculators.where((calc) {
      return calc.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          calc.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedGradientBackground(isDark: isDark, child: Container()),
          // Floating particles
          Positioned.fill(child: FloatingParticles(isDark: isDark)),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header with Search and Wave overlay
                Stack(
                  children: [
                    // Wave pattern at bottom of header
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 60,
                      child: WavePattern(isDark: isDark),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.asset(
                                      'assets/icons/app-icon.png',
                                      height: 36,
                                      width: 36,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'LoanBee',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
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
                                  onPressed: () =>
                                      themeController.toggleTheme(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Search Bar
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Search calculators...',
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Calculator Grid with Tip
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Financial Tip Banner
                        FadeTransition(
                          opacity: _tipAnimation,
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [
                                        AppTheme.darkCard,
                                        AppTheme.darkCard.withValues(
                                          alpha: 0.8,
                                        ),
                                      ]
                                    : [
                                        AppTheme.primaryOrange.withValues(
                                          alpha: 0.1,
                                        ),
                                        AppTheme.primaryYellow.withValues(
                                          alpha: 0.1,
                                        ),
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppTheme.primaryOrange.withValues(
                                        alpha: 0.3,
                                      )
                                    : AppTheme.primaryOrange.withValues(
                                        alpha: 0.2,
                                      ),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange.withValues(
                                      alpha: 0.2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lightbulb_outline,
                                    color: AppTheme.primaryOrange,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _financialTips[_currentTipIndex],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Calculator Grid
                        Expanded(
                          child: _filteredCalculators.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: Colors.grey.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No calculators found',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 0.85,
                                      ),
                                  itemCount: _filteredCalculators.length,
                                  itemBuilder: (context, index) {
                                    final calc = _filteredCalculators[index];
                                    return _AnimatedCalculatorTile(
                                      index: index,
                                      icon: calc.icon,
                                      title: calc.title,
                                      subtitle: calc.subtitle,
                                      color: calc.color,
                                      onTap: () => Navigator.of(
                                        context,
                                      ).push(SlidePageRoute(page: calc.screen)),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget screen;

  _CalculatorItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.screen,
  });
}

class _AnimatedCalculatorTile extends StatefulWidget {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedCalculatorTile({
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AnimatedCalculatorTile> createState() =>
      _AnimatedCalculatorTileState();
}

class _AnimatedCalculatorTileState extends State<_AnimatedCalculatorTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.icon, size: 28, color: widget.color),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
