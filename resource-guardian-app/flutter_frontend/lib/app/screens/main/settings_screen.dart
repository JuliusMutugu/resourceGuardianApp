import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;
  bool _autoBackup = true;
  String _currency = 'KSh';
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            _buildProfileSection(),
            
            const SizedBox(height: AppSizes.lg),
            
            // Preferences Section
            _buildSection(
              'Preferences',
              [
                _buildSwitchTile(
                  'Dark Mode',
                  'Switch between light and dark theme',
                  Icons.dark_mode,
                  context.watch<ThemeProvider>().isDarkMode,
                  (value) => context.read<ThemeProvider>().toggleTheme(),
                ),
                _buildDropdownTile(
                  'Language',
                  'Choose your preferred language',
                  Icons.language,
                  _language,
                  ['English', 'Swahili', 'French'],
                  (value) => setState(() => _language = value!),
                ),
                _buildDropdownTile(
                  'Currency',
                  'Set your default currency',
                  Icons.attach_money,
                  _currency,
                  ['KSh', 'USD', 'EUR', 'GBP'],
                  (value) => setState(() => _currency = value!),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.lg),
            
            // Security Section
            _buildSection(
              'Security & Privacy',
              [
                _buildSwitchTile(
                  'Biometric Login',
                  'Use fingerprint or face ID to login',
                  Icons.fingerprint,
                  _biometricsEnabled,
                  (value) => setState(() => _biometricsEnabled = value),
                ),
                _buildNavigationTile(
                  'Change Password',
                  'Update your account password',
                  Icons.lock_outline,
                  () => _showChangePasswordDialog(),
                ),
                _buildNavigationTile(
                  'Two-Factor Authentication',
                  'Add an extra layer of security',
                  Icons.security,
                  () => _show2FADialog(),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.lg),
            
            // Notifications Section
            _buildSection(
              'Notifications',
              [
                _buildSwitchTile(
                  'Push Notifications',
                  'Receive important updates',
                  Icons.notifications_outlined,
                  _notificationsEnabled,
                  (value) => setState(() => _notificationsEnabled = value),
                ),
                _buildNavigationTile(
                  'Notification Preferences',
                  'Customize what notifications you receive',
                  Icons.tune,
                  () => _showNotificationPreferences(),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.lg),
            
            // Data Section
            _buildSection(
              'Data & Storage',
              [
                _buildSwitchTile(
                  'Auto Backup',
                  'Automatically backup your data',
                  Icons.backup,
                  _autoBackup,
                  (value) => setState(() => _autoBackup = value),
                ),
                _buildNavigationTile(
                  'Export Data',
                  'Download your financial data',
                  Icons.download,
                  () => _showExportDialog(),
                ),
                _buildNavigationTile(
                  'Clear Cache',
                  'Free up storage space',
                  Icons.cleaning_services,
                  () => _showClearCacheDialog(),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.lg),
            
            // Support Section
            _buildSection(
              'Support & About',
              [
                _buildNavigationTile(
                  'Help Center',
                  'Get help and support',
                  Icons.help_outline,
                  () => _openHelpCenter(),
                ),
                _buildNavigationTile(
                  'Contact Us',
                  'Send feedback or report issues',
                  Icons.contact_support,
                  () => _openContactUs(),
                ),
                _buildNavigationTile(
                  'Privacy Policy',
                  'Read our privacy policy',
                  Icons.privacy_tip,
                  () => _openPrivacyPolicy(),
                ),
                _buildNavigationTile(
                  'Terms of Service',
                  'Read our terms of service',
                  Icons.description,
                  () => _openTermsOfService(),
                ),
                _buildNavigationTile(
                  'About App',
                  'Version 1.0.0',
                  Icons.info_outline,
                  () => _showAboutDialog(),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.lg),
            
            // Logout Button
            _buildLogoutButton(),
            
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authProvider.user?.name ?? 'User',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      authProvider.user?.email ?? 'user@example.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showEditProfileDialog(),
                icon: const Icon(Icons.edit_outlined),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.gray100,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppColors.textSecondary),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildNavigationTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.gray400),
      onTap: onTap,
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppColors.textSecondary),
      ),
      trailing: DropdownButton<String>(
        value: value,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
        underline: Container(),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Dialog methods
  void _showEditProfileDialog() {
    // TODO: Implement edit profile dialog
    _showSnackBar('Edit profile feature coming soon!');
  }

  void _showChangePasswordDialog() {
    // TODO: Implement change password dialog
    _showSnackBar('Change password feature coming soon!');
  }

  void _show2FADialog() {
    // TODO: Implement 2FA setup dialog
    _showSnackBar('Two-factor authentication setup coming soon!');
  }

  void _showNotificationPreferences() {
    // TODO: Navigate to notification preferences screen
    _showSnackBar('Notification preferences coming soon!');
  }

  void _showExportDialog() {
    // TODO: Implement data export
    _showSnackBar('Data export feature coming soon!');
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the app cache? This will free up storage space.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Cache cleared successfully!');
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _openHelpCenter() {
    // TODO: Navigate to help center
    _showSnackBar('Help center coming soon!');
  }

  void _openContactUs() {
    // TODO: Open contact form or email
    _showSnackBar('Contact us feature coming soon!');
  }

  void _openPrivacyPolicy() {
    // TODO: Open privacy policy
    _showSnackBar('Privacy policy coming soon!');
  }

  void _openTermsOfService() {
    // TODO: Open terms of service
    _showSnackBar('Terms of service coming soon!');
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Resource Guardian',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.account_balance_wallet,
          color: Colors.white,
          size: 32,
        ),
      ),
      children: [
        const Text(
          'A modern financial management and digital wellness application designed for young adults.',
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().logout();
              // TODO: Navigate to login screen
              _showSnackBar('Logged out successfully!');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }
}
