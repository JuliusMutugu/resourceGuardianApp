import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/enhanced_ui_components.dart';
import '../../models/transaction.dart';

class EnhancedTransactionsScreen extends StatefulWidget {
  const EnhancedTransactionsScreen({super.key});

  @override
  State<EnhancedTransactionsScreen> createState() => _EnhancedTransactionsScreenState();
}

class _EnhancedTransactionsScreenState extends State<EnhancedTransactionsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _selectedSort = 'Date';
  DateTimeRange? _selectedDateRange;
  
  final List<String> _filterOptions = ['All', 'Income', 'Expense', 'Transfer'];
  final List<String> _sortOptions = ['Date', 'Amount', 'Category'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Analytics'),
            Tab(text: 'Categories'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showSearchBottomSheet,
            icon: const Icon(Icons.search),
            tooltip: 'Search transactions',
          ),
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter & Sort',
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }

          if (provider.error != null) {
            return _buildErrorState(provider);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildTransactionsList(provider),
              _buildAnalyticsTab(provider),
              _buildCategoriesTab(provider),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTransactionBottomSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
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
          Text('Loading transactions...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(TransactionProvider provider) {
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
              'Failed to load transactions',
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
              onPressed: () => provider.loadTransactions(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(TransactionProvider provider) {
    final transactions = _getFilteredTransactions(provider.transactions);

    if (transactions.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadTransactions(),
      child: Column(
        children: [
          if (_hasActiveFilters()) _buildActiveFiltersChip(),
          _buildQuickStats(transactions),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildTransactionItem(transaction, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.xl),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            Text(
              'No transactions yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Start tracking your finances by adding your first transaction',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xl),
            ElevatedButton.icon(
              onPressed: _showAddTransactionBottomSheet,
              icon: const Icon(Icons.add),
              label: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFiltersChip() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          if (_selectedFilter != 'All')
            Chip(
              label: Text(_selectedFilter),
              onDeleted: () {
                setState(() {
                  _selectedFilter = 'All';
                });
              },
            ),
          if (_selectedDateRange != null) ...[
            const SizedBox(width: AppSizes.sm),
            Chip(
              label: Text(
                '${DateFormat('MMM d').format(_selectedDateRange!.start)} - '
                '${DateFormat('MMM d').format(_selectedDateRange!.end)}',
              ),
              onDeleted: () {
                setState(() {
                  _selectedDateRange = null;
                });
              },
            ),
          ],
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedFilter = 'All';
                _selectedSort = 'Date';
                _selectedDateRange = null;
              });
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(List<Transaction> transactions) {
    final totalIncome = transactions
        .where((t) => (t.amount ?? 0) > 0)
        .fold(0.0, (sum, t) => sum + (t.amount ?? 0));
    
    final totalExpense = transactions
        .where((t) => (t.amount ?? 0) < 0)
        .fold(0.0, (sum, t) => sum + (t.amount ?? 0).abs());
    
    final balance = totalIncome - totalExpense;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Expanded(
            child: StatsCard(
              title: 'Income',
              value: '\$${NumberFormat('#,##0.00').format(totalIncome)}',
              subtitle: '${transactions.where((t) => (t.amount ?? 0) > 0).length} transactions',
              icon: Icons.trending_up,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: StatsCard(
              title: 'Expense',
              value: '\$${NumberFormat('#,##0.00').format(totalExpense)}',
              subtitle: '${transactions.where((t) => (t.amount ?? 0) < 0).length} transactions',
              icon: Icons.trending_down,
              color: AppColors.error,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: StatsCard(
              title: 'Balance',
              value: '\$${NumberFormat('#,##0.00').format(balance)}',
              subtitle: 'Net amount',
              icon: Icons.account_balance,
              color: balance >= 0 ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction, int index) {
    final isIncome = (transaction.amount ?? 0) > 0;
    final amount = (transaction.amount ?? 0).abs();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Hero(
            tag: 'transaction_icon_$index',
            child: Container(
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: (isIncome ? AppColors.success : AppColors.error).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                _getCategoryIcon(transaction.category),
                color: isIncome ? AppColors.success : AppColors.error,
                size: 24,
              ),
            ),
          ),
          title: Text(
            transaction.description ?? 'Transaction',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.category ?? 'General',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                _formatTransactionDate(transaction.date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}\$${NumberFormat('#,##0.00').format(amount)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isIncome ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (transaction.mpesaTransactionId != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                  ),
                  child: Text(
                    'M-Pesa',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () {
            _showTransactionDetails(transaction);
          },
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab(TransactionProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Analytics',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          _buildSpendingTrendChart(provider),
          const SizedBox(height: AppSizes.xl),
          _buildCategoryBreakdown(provider),
          const SizedBox(height: AppSizes.xl),
          _buildMonthlyComparison(provider),
        ],
      ),
    );
  }

  Widget _buildSpendingTrendChart(TransactionProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Trend (Last 7 Days)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Chart visualization would go here',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(TransactionProvider provider) {
    final categories = _getCategoryBreakdown(provider.transactions);
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          ...categories.entries.map((entry) => _buildCategoryItem(entry)),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(MapEntry<String, double> entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(
              _getCategoryIcon(entry.key),
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSizes.xs),
                AnimatedProgressBar(
                  progress: 0.7, // This would be calculated based on total
                  height: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Text(
            '\$${NumberFormat('#,##0.00').format(entry.value)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyComparison(TransactionProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Comparison',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Row(
            children: [
              Expanded(
                child: _buildMonthlyComparisonItem(
                  'This Month',
                  2850.00,
                  '+12.5%',
                  true,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: _buildMonthlyComparisonItem(
                  'Last Month',
                  2536.50,
                  '-8.2%',
                  false,
                  AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyComparisonItem(
    String title,
    double amount,
    String trend,
    bool isPositive,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            '\$${NumberFormat('#,##0.00').format(amount)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: color,
                size: 16,
              ),
              const SizedBox(width: AppSizes.xs),
              Text(
                trend,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab(TransactionProvider provider) {
    return const Center(
      child: Text('Categories management coming soon...'),
    );
  }

  List<Transaction> _getFilteredTransactions(List<Transaction> transactions) {
    var filtered = transactions.where((transaction) {
      // Filter by type
      if (_selectedFilter != 'All') {
        final amount = transaction.amount ?? 0;
        switch (_selectedFilter) {
          case 'Income':
            if (amount <= 0) return false;
            break;
          case 'Expense':
            if (amount >= 0) return false;
            break;
          case 'Transfer':
            // Add transfer logic here
            break;
        }
      }

      // Filter by date range
      if (_selectedDateRange != null && transaction.date != null) {
        final transactionDate = transaction.date!;
        if (transactionDate.isBefore(_selectedDateRange!.start) ||
            transactionDate.isAfter(_selectedDateRange!.end)) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort transactions
    switch (_selectedSort) {
      case 'Date':
        filtered.sort((a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));
        break;
      case 'Amount':
        filtered.sort((a, b) => (b.amount ?? 0).abs().compareTo((a.amount ?? 0).abs()));
        break;
      case 'Category':
        filtered.sort((a, b) => (a.category ?? '').compareTo(b.category ?? ''));
        break;
    }

    return filtered;
  }

  Map<String, double> _getCategoryBreakdown(List<Transaction> transactions) {
    final breakdown = <String, double>{};
    
    for (final transaction in transactions) {
      if ((transaction.amount ?? 0) < 0) { // Only expenses
        final category = transaction.category ?? 'Other';
        breakdown[category] = (breakdown[category] ?? 0) + (transaction.amount ?? 0).abs();
      }
    }
    
    return Map.fromEntries(
      breakdown.entries.toList()..sort((a, b) => b.value.compareTo(a.value))
    );
  }

  bool _hasActiveFilters() {
    return _selectedFilter != 'All' || _selectedDateRange != null;
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'food':
      case 'restaurant':
        return Icons.restaurant;
      case 'transport':
      case 'gas':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'health':
      case 'medical':
        return Icons.medical_services;
      case 'utilities':
        return Icons.home;
      case 'salary':
      case 'income':
        return Icons.work;
      default:
        return Icons.category;
    }
  }

  String _formatTransactionDate(DateTime? date) {
    if (date == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today ${DateFormat('HH:mm').format(date)}';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  void _showSearchBottomSheet() {
    // TODO: Implement search bottom sheet
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter & Sort',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                Text(
                  'Filter by Type',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Wrap(
                  spacing: AppSizes.sm,
                  children: _filterOptions.map((filter) {
                    return FilterChip(
                      label: Text(filter),
                      selected: _selectedFilter == filter,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSizes.lg),
                Text(
                  'Sort by',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Wrap(
                  spacing: AppSizes.sm,
                  children: _sortOptions.map((sort) {
                    return FilterChip(
                      label: Text(sort),
                      selected: _selectedSort == sort,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSort = sort;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddTransactionBottomSheet() {
    // TODO: Implement add transaction bottom sheet
  }

  void _showTransactionDetails(Transaction transaction) {
    // TODO: Implement transaction details page
  }
}
