import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../widgets/enhanced_ui_components.dart';
import '../../providers/digital_wellness_provider.dart';

class DigitalWellnessScreen extends StatefulWidget {
  const DigitalWellnessScreen({super.key});

  @override
  State<DigitalWellnessScreen> createState() => _DigitalWellnessScreenState();
}

class _DigitalWellnessScreenState extends State<DigitalWellnessScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DigitalWellnessProvider>().loadUsageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Wellness'),
        actions: [
          IconButton(
            onPressed: () {
              _showSettingsBottomSheet(context);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<DigitalWellnessProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTodayOverview(provider),
                const SizedBox(height: AppSizes.xl),
                _buildAppUsageStats(provider),
                const SizedBox(height: AppSizes.xl),
                _buildWeeklyTrend(provider),
                const SizedBox(height: AppSizes.xl),
                _buildAppLimits(provider),
                const SizedBox(height: AppSizes.xl),
                _buildDigitalDetox(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodayOverview(DigitalWellnessProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Usage',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Screen Time',
                value: provider.todayScreenTime,
                subtitle: 'Total today',
                icon: Icons.phone_android,
                color: AppColors.primary,
                trend: provider.screenTimeTrend,
                isPositiveTrend: provider.isScreenTimeTrendPositive,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: StatsCard(
                title: 'Pickups',
                value: '${provider.todayPickups}',
                subtitle: 'Times unlocked',
                icon: Icons.touch_app,
                color: AppColors.secondary,
                trend: provider.pickupsTrend,
                isPositiveTrend: provider.isPickupsTrendPositive,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppUsageStats(DigitalWellnessProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'App Usage',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Show all apps
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        ...provider.topApps.map((app) => _buildAppUsageItem(app)),
      ],
    );
  }

  Widget _buildAppUsageItem(AppUsage app) {
    final progress = app.usageMinutes / (app.limitMinutes > 0 ? app.limitMinutes : 480); // 8 hours default
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: progress > 1.0 ? AppColors.error : AppColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: app.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  app.icon,
                  color: app.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          app.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          app.formattedUsageTime,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: progress > 1.0 ? AppColors.error : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      '${app.sessionsCount} sessions',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (app.limitMinutes > 0) ...[
            const SizedBox(height: AppSizes.md),
            AnimatedProgressBar(
              progress: progress.clamp(0.0, 1.0),
              color: progress > 0.8 ? AppColors.error : AppColors.primary,
              height: 4,
            ),
            const SizedBox(height: AppSizes.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Limit: ${app.formattedLimitTime}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (progress > 1.0)
                  Text(
                    'Limit exceeded',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeeklyTrend(DigitalWellnessProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Trend',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Container(
          height: 200,
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.gray200),
          ),
          child: _buildWeeklyChart(provider.weeklyData),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(List<DailyUsage> weeklyData) {
    if (weeklyData.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    final maxUsage = weeklyData.map((d) => d.totalMinutes).reduce((a, b) => a > b ? a : b);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: weeklyData.map((day) {
        final height = maxUsage > 0 ? (day.totalMinutes / maxUsage * 140) : 0.0;
        final isToday = day.date.day == DateTime.now().day;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${(day.totalMinutes / 60).toStringAsFixed(1)}h',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Container(
              width: 20,
              height: height.clamp(20.0, 140.0),
              decoration: BoxDecoration(
                color: isToday ? AppColors.primary : AppColors.gray300,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              day.dayName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isToday ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAppLimits(DigitalWellnessProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'App Limits',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                _showAddLimitBottomSheet(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Limit'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        if (provider.appLimits.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Column(
              children: [
                Icon(
                  Icons.timer_off_outlined,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'No app limits set',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Set limits to control your app usage',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          ...provider.appLimits.map((limit) => _buildAppLimitItem(limit)),
      ],
    );
  }

  Widget _buildAppLimitItem(AppLimit limit) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      child: FeatureCard(
        title: limit.appName,
        subtitle: 'Limit: ${limit.formattedLimit}',
        icon: limit.appIcon,
        iconColor: limit.isActive ? AppColors.primary : AppColors.gray400,
        onTap: () {
          _showEditLimitBottomSheet(context, limit);
        },
        trailing: Switch(
          value: limit.isActive,
          onChanged: (value) {
            // TODO: Toggle limit
          },
        ),
      ),
    );
  }

  Widget _buildDigitalDetox(DigitalWellnessProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Digital Detox',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        FeatureCard(
          title: 'Focus Mode',
          subtitle: provider.isFocusModeActive 
              ? 'Active - Distracting apps are blocked' 
              : 'Block distracting apps to stay focused',
          icon: Icons.visibility_off,
          iconColor: provider.isFocusModeActive ? AppColors.success : AppColors.gray400,
          onTap: () {
            provider.toggleFocusMode();
          },
          trailing: Switch(
            value: provider.isFocusModeActive,
            onChanged: (value) {
              provider.toggleFocusMode();
            },
          ),
        ),
        const SizedBox(height: AppSizes.md),
        FeatureCard(
          title: 'Sleep Mode',
          subtitle: provider.isSleepModeActive 
              ? 'Active - All notifications are silenced' 
              : 'Schedule quiet hours for better sleep',
          icon: Icons.bedtime,
          iconColor: provider.isSleepModeActive ? AppColors.secondary : AppColors.gray400,
          onTap: () {
            _showSleepModeSettings(context);
          },
          trailing: Switch(
            value: provider.isSleepModeActive,
            onChanged: (value) {
              provider.toggleSleepMode();
            },
          ),
        ),
      ],
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Digital Wellness Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Settings'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to notification settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.apps),
              title: const Text('App Permissions'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to app permissions
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Usage Reports'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to usage reports
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLimitBottomSheet(BuildContext context) {
    // TODO: Implement add limit bottom sheet
  }

  void _showEditLimitBottomSheet(BuildContext context, AppLimit limit) {
    // TODO: Implement edit limit bottom sheet
  }

  void _showSleepModeSettings(BuildContext context) {
    // TODO: Implement sleep mode settings
  }
}
