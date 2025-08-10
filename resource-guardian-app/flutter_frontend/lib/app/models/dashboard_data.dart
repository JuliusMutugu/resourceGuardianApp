import 'user.dart';
import 'transaction.dart';
import 'savings_goal.dart';

class DashboardData {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final List<SavingsGoal> savingsGoals;
  final List<Transaction> recentTransactions;

  DashboardData({
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.savingsGoals,
    required this.recentTransactions,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalBalance: json['totalBalance'].toDouble(),
      monthlyIncome: json['monthlyIncome'].toDouble(),
      monthlyExpenses: json['monthlyExpenses'].toDouble(),
      savingsGoals: (json['savingsGoals'] as List)
          .map((goal) => SavingsGoal.fromJson(goal))
          .toList(),
      recentTransactions: (json['recentTransactions'] as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBalance': totalBalance,
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
      'savingsGoals': savingsGoals.map((goal) => goal.toJson()).toList(),
      'recentTransactions': recentTransactions.map((transaction) => transaction.toJson()).toList(),
    };
  }

  double get netIncome => monthlyIncome - monthlyExpenses;
  double get savingsRate => monthlyIncome > 0 ? (netIncome / monthlyIncome) : 0;
}
