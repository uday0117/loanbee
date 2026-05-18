import 'package:flutter/material.dart';
import 'package:loanbee/controllers/theme_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = '${packageInfo.version}+${packageInfo.buildNumber}';
      });
    } catch (e) {
      setState(() {
        _version = '1.0.0';
      });
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open link')));
      }
    }
  }

  Future<void> _shareApp() async {
    await Share.share(
      'Check out LoanBee - Your all-in-one financial calculator app!\n\n'
      'Calculate EMI, Loan Eligibility, SIP, FD/RD, GST, Currency Exchange, and Amortization.\n\n'
      'Download now: https://play.google.com/store/apps/details?id=com.uksolutions.loanbee',
      subject: 'LoanBee - Financial Calculator',
    );
  }

  void _showRateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate LoanBee'),
        content: const Text(
          'The app is not yet published on Play Store. '
          'Once published, you can rate us directly from the store!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Profile Header with Gradient
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFFFF8C42), Color(0xFFFFD93D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      child: Image.asset(
                        'assets/icons/app-icon.png',
                        height: 60,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'LoanBee',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Financial Calculator',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Settings List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildSettingsTile(
                  context,
                  icon: themeController.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  title: 'Theme',
                  subtitle: themeController.isDarkMode
                      ? 'Dark Mode'
                      : 'Light Mode',
                  trailing: Switch(
                    value: themeController.isDarkMode,
                    onChanged: (_) => themeController.toggleTheme(),
                  ),
                ),
                const Divider(height: 1, indent: 72),
                _buildSettingsTile(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'Version $_version',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'LoanBee',
                      applicationVersion: _version,
                      applicationIcon: Image.asset(
                        'assets/icons/app-icon.png',
                        height: 50,
                      ),
                      children: const [
                        Text('Your all-in-one financial calculator app.'),
                      ],
                    );
                  },
                ),
                const Divider(height: 1, indent: 72),
                _buildSettingsTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => _openUrl(
                    'https://uday0117.github.io/loanbee/privacy_policy.html',
                  ),
                ),
                const Divider(height: 1, indent: 72),
                _buildSettingsTile(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  onTap: () => _openUrl(
                    'https://uday0117.github.io/loanbee/terms_and_conditions.html',
                  ),
                ),
                const Divider(height: 1, indent: 72),
                _buildSettingsTile(
                  context,
                  icon: Icons.share_outlined,
                  title: 'Share App',
                  onTap: _shareApp,
                ),
                const Divider(height: 1, indent: 72),
                _buildSettingsTile(
                  context,
                  icon: Icons.star_outline,
                  title: 'Rate Us',
                  subtitle: 'On Play Store',
                  onTap: _showRateDialog,
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'Made with ❤️ by UK Solutions',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF8C42)),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
