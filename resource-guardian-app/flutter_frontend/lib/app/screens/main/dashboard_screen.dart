import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/savings_goal_card.dart';
import '../../widgets/transaction_list_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboardData();
    });
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
              return const Center(child: CircularProgressIndicator());
            }

            if (dashboardProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      'Failed to load dashboard',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      dashboardProvider.error!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.lg),
                    ElevatedButton(
                      onPressed: () => dashboardProvider.loadDashboardData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final data = dashboardProvider.dashboardData;
            if (data == null) {
              return const Center(child: Text('No data available'));
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: AppSizes.lg),

                    // Balance Overview
                    _buildBalanceOverview(data),
                    const SizedBox(height: AppSizes.lg),

                    // Savings Goals
                    _buildSavingsGoals(data),
                    const SizedBox(height: AppSizes.lg),

                    // Recent Transactions
                    _buildRecentTransactions(data),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Welcome back',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceOverview(dashboardData) {
    return BalanceCard(
      totalBalance: dashboardData.totalBalance,
      monthlyIncome: dashboardData.monthlyIncome,
      monthlyExpenses: dashboardData.monthlyExpenses,
    );
  }

  Widget _buildSavingsGoals(dashboardData) {
    if (dashboardData.savingsGoals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Savings Goals',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to goals screen
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dashboardData.savingsGoals.length,
            itemBuilder: (context, index) {
              final goal = dashboardData.savingsGoals[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < dashboardData.savingsGoals.length - 1 ? AppSizes.md : 0,
                ),
                child: SavingsGoalCard(goal: goal),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(dashboardData) {
    if (dashboardData.recentTransactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to transactions screen
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dashboardData.recentTransactions.length.clamp(0, 5),
          separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
          itemBuilder: (context, index) {
            final transaction = dashboardData.recentTransactions[index];
            return TransactionListItem(transaction: transaction);
          },
        ),
      ],
    );
  }
}
