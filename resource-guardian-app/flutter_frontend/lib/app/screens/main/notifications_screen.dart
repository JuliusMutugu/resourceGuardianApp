import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../providers/theme_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Sample notification settings - in a real app, these would come from a provider
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool budgetAlerts = true;
  bool goalReminders = true;
  bool expenseWarnings = true;
  bool weeklyReports = false;
  bool monthlyReports = true;
  bool promotionalOffers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Stay Updated',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    'Customize your notification preferences to stay informed about your finances.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xl),

            // General Settings
            _buildSection(
              context,
              'General',
              [
                _buildSwitchTile(
                  context,
                  'Push Notifications',
                  'Receive notifications on your device',
                  Icons.phone_android_outlined,
                  pushNotifications,
                  (value) => setState(() => pushNotifications = value),
                ),
                _buildSwitchTile(
                  context,
                  'Email Notifications',
                  'Receive notifications via email',
                  Icons.email_outlined,
                  emailNotifications,
                  (value) => setState(() => emailNotifications = value),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),

            // Financial Alerts
            _buildSection(
              context,
              'Financial Alerts',
              [
                _buildSwitchTile(
                  context,
                  'Budget Alerts',
                  'Get notified when approaching budget limits',
                  Icons.account_balance_wallet_outlined,
                  budgetAlerts,
                  (value) => setState(() => budgetAlerts = value),
                ),
                _buildSwitchTile(
                  context,
                  'Goal Reminders',
                  'Receive reminders about your savings goals',
                  Icons.flag_outlined,
                  goalReminders,
                  (value) => setState(() => goalReminders = value),
                ),
                _buildSwitchTile(
                  context,
                  'Expense Warnings',
                  'Get alerts for unusual spending patterns',
                  Icons.warning_amber_outlined,
                  expenseWarnings,
                  (value) => setState(() => expenseWarnings = value),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),

            // Reports
            _buildSection(
              context,
              'Reports',
              [
                _buildSwitchTile(
                  context,
                  'Weekly Reports',
                  'Receive weekly spending summaries',
                  Icons.calendar_view_week_outlined,
                  weeklyReports,
                  (value) => setState(() => weeklyReports = value),
                ),
                _buildSwitchTile(
                  context,
                  'Monthly Reports',
                  'Receive detailed monthly financial reports',
                  Icons.calendar_month_outlined,
                  monthlyReports,
                  (value) => setState(() => monthlyReports = value),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),

            // Marketing
            _buildSection(
              context,
              'Marketing',
              [
                _buildSwitchTile(
                  context,
                  'Promotional Offers',
                  'Receive information about new features and offers',
                  Icons.local_offer_outlined,
                  promotionalOffers,
                  (value) => setState(() => promotionalOffers = value),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xl),

            // Save Button
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _saveNotificationSettings();
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save Preferences'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSizes.sm, bottom: AppSizes.md),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: value 
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                icon,
                color: value ? AppColors.primary : AppColors.textSecondary,
                size: AppSizes.iconMd,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _saveNotificationSettings() {
    // In a real app, you would save these settings to a backend or local storage
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification preferences saved!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }
}
