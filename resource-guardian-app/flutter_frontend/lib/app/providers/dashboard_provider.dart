import 'package:flutter/material.dart';
import '../models/dashboard_data.dart';
import '../models/transaction.dart';
import '../models/savings_goal.dart';
import '../services/api_service.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  DashboardData? _dashboardData;
  bool _isLoading = false;
  String? _error;

  DashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // For now, using mock data
      _dashboardData = _getMockDashboardData();
      // TODO: Replace with actual API call
      // _dashboardData = await _apiService.getDashboardData();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading dashboard data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshDashboardData() async {
    await loadDashboardData();
  }

  DashboardData _getMockDashboardData() {
    return DashboardData(
      totalBalance: 15420.50,
      monthlyIncome: 5200.00,
      monthlyExpenses: 3180.25,
      savingsGoals: [
        SavingsGoal(
          id: '1',
          name: 'Emergency Fund',
          targetAmount: 10000,
          currentAmount: 6500,
          deadline: DateTime(2025, 12, 31),
          isActive: true,
          userId: 'user1',
        ),
        SavingsGoal(
          id: '2',
          name: 'Vacation',
          targetAmount: 3000,
          currentAmount: 1200,
          deadline: DateTime(2025, 6, 15),
          isActive: true,
          userId: 'user1',
        ),
      ],
      recentTransactions: [
        Transaction(
          id: '1',
          amount: 150.00,
          description: 'Grocery Shopping',
          category: 'Food & Dining',
          type: TransactionType.expense,
          date: DateTime.now().subtract(const Duration(days: 1)),
          userId: 'user1',
        ),
        Transaction(
          id: '2',
          amount: 2500.00,
          description: 'Salary',
          category: 'Income',
          type: TransactionType.income,
          date: DateTime.now().subtract(const Duration(days: 2)),
          userId: 'user1',
        ),
        Transaction(
          id: '3',
          amount: 80.00,
          description: 'Gas Station',
          category: 'Transportation',
          type: TransactionType.expense,
          date: DateTime.now().subtract(const Duration(days: 3)),
          userId: 'user1',
        ),
      ],
    );
  }
}
