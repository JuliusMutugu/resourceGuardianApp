import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/enhanced_ui_components.dart';
import '../../widgets/balance_card.dart';

class EnhancedDashboardScreen extends StatefulWidget {
  const EnhancedDashboardScreen({super.key});

  @override
  State<EnhancedDashboardScreen> createState() => _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState extends State<EnhancedDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboardData();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<DashboardProvider>().refreshDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<DashboardProvider>(
          builder: (context, dashboardProvider, _) {
            if (dashboardProvider.isLoading && dashboardProvider.dashboardData == null) {
              return _buildLoadingState();
            }

            if (dashboardProvider.error != null) {
              return _buildErrorState(dashboardProvider);
            }

            final data = dashboardProvider.dashboardData;
            if (data == null) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        _buildHeader(context),
                        _buildQuickActions(context),
                        _buildStatsOverview(data),
                        _buildFinancialSummary(data),
                        _buildSavingsGoals(data),
                        _buildRecentActivity(data),
                        _buildDigitalWellness(),
                        const SizedBox(height: AppSizes.xl),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppSizes.md),
          Text('Loading your financial overview...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(DashboardProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              provider.error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xl),
            ElevatedButton.icon(
              onPressed: () => provider.loadDashboardData(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'No data available',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Start by adding your first transaction',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  DateFormat('EEEE, MMM d').format(now),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return IconButton(
                    onPressed: themeProvider.toggleTheme,
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    tooltip: 'Toggle theme',
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  // TODO: Navigate to notifications
                },
                icon: const Icon(Icons.notifications_outlined),
                tooltip: 'Notifications',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              QuickActionButton(
                label: 'Add Income',
                icon: Icons.add_circle,
                backgroundColor: AppColors.success,
                onPressed: () {
                  // TODO: Navigate to add income
                },
              ),
              QuickActionButton(
                label: 'Add Expense',
                icon: Icons.remove_circle,
                backgroundColor: AppColors.error,
                onPressed: () {
                  // TODO: Navigate to add expense
                },
              ),
              QuickActionButton(
                label: 'Transfer',
                icon: Icons.swap_horiz,
                backgroundColor: AppColors.warning,
                onPressed: () {
                  // TODO: Navigate to transfer
                },
              ),
              QuickActionButton(
                label: 'Goals',
                icon: Icons.track_changes,
                backgroundColor: AppColors.primary,
                onPressed: () {
                  // TODO: Navigate to goals
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(dynamic data) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 180,
                  child: StatsCard(
                    title: 'Total Balance',
                    value: '\$${NumberFormat('#,##0.00').format(data.totalBalance ?? 0)}',
                    subtitle: 'Available funds',
                    icon: Icons.account_balance_wallet,
                    color: AppColors.primary,
                    trend: '+5.2%',
                    isPositiveTrend: true,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                SizedBox(
                  width: 180,
                  child: StatsCard(
                    title: 'This Month',
                    value: '\$${NumberFormat('#,##0.00').format(data.monthlyIncome ?? 0)}',
                    subtitle: 'Income',
                    icon: Icons.trending_up,
                    color: AppColors.success,
                    trend: '+12.8%',
                    isPositiveTrend: true,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                SizedBox(
                  width: 180,
                  child: StatsCard(
                    title: 'Expenses',
                    value: '\$${NumberFormat('#,##0.00').format(data.monthlyExpenses ?? 0)}',
                    subtitle: 'This month',
                    icon: Icons.trending_down,
                    color: AppColors.error,
                    trend: '-3.1%',
                    isPositiveTrend: false,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                SizedBox(
                  width: 180,
                  child: StatsCard(
                    title: 'Savings Rate',
                    value: '${((data.monthlyIncome - data.monthlyExpenses) / data.monthlyIncome * 100).toStringAsFixed(1)}%',
                    subtitle: 'Of income',
                    icon: Icons.savings,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary(dynamic data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: BalanceCard(
        totalBalance: data.totalBalance ?? 0,
        monthlyIncome: data.monthlyIncome ?? 0,
        monthlyExpenses: data.monthlyExpenses ?? 0,
      ),
    );
  }

  Widget _buildSavingsGoals(dynamic data) {
    final goals = data.savingsGoals as List? ?? [];
    
    if (goals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Savings Goals',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all goals
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          ...goals.take(3).map((goal) => _buildSavingsGoalItem(goal)),
        ],
      ),
    );
  }

  Widget _buildSavingsGoalItem(dynamic goal) {
    final progress = (goal.currentAmount ?? 0) / (goal.targetAmount ?? 1);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                goal.name ?? 'Savings Goal',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          AnimatedProgressBar(
            progress: progress,
            color: AppColors.primary,
            height: 6,
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${NumberFormat('#,##0.00').format(goal.currentAmount ?? 0)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '\$${NumberFormat('#,##0.00').format(goal.targetAmount ?? 0)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(dynamic data) {
    final transactions = data.recentTransactions as List? ?? [];
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all transactions
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          if (transactions.isEmpty)
            _buildEmptyTransactions()
          else
            ...transactions.take(5).map((transaction) => _buildTransactionItem(transaction)),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'No recent transactions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Your transaction history will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(dynamic transaction) {
    final isIncome = (transaction.amount ?? 0) > 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: (isIncome ? AppColors.success : AppColors.error).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(
            isIncome ? Icons.add : Icons.remove,
            color: isIncome ? AppColors.success : AppColors.error,
            size: 20,
          ),
        ),
        title: Text(
          transaction.description ?? 'Transaction',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          transaction.category ?? 'General',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}\$${NumberFormat('#,##0.00').format((transaction.amount ?? 0).abs())}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isIncome ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _formatTransactionDate(transaction.date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalWellness() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.lg),
      child: FeatureCard(
        title: 'Digital Wellness',
        subtitle: 'Monitor your app usage and digital habits',
        icon: Icons.phone_android,
        iconColor: AppColors.secondary,
        onTap: () {
          // TODO: Navigate to digital wellness
        },
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Text(
            '2h 45m today',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  String _formatTransactionDate(dynamic date) {
    if (date == null) return '';
    
    try {
      final DateTime dateTime = date is DateTime ? date : DateTime.parse(date.toString());
      final now = DateTime.now();
      final difference = now.difference(dateTime).inDays;
      
      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Yesterday';
      } else if (difference < 7) {
        return '${difference}d ago';
      } else {
        return DateFormat('MMM d').format(dateTime);
      }
    } catch (e) {
      return '';
    }
  }
}
