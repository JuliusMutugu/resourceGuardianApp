import 'package:flutter/material.dart';
import '../models/savings_goal.dart';
import '../services/api_service.dart';

class GoalsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<SavingsGoal> _goals = [];
  bool _isLoading = false;
  String? _error;

  List<SavingsGoal> get goals => _goals;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<SavingsGoal> get activeGoals => _goals.where((goal) => goal.isActive).toList();
  List<SavingsGoal> get completedGoals => _goals.where((goal) => goal.isCompleted).toList();

  Future<void> loadGoals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // For now, using mock data
      _goals = _getMockGoals();
      // TODO: Replace with actual API call
      // _goals = await _apiService.getSavingsGoals();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading goals: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addGoal(SavingsGoal goal) async {
    try {
      // TODO: Replace with actual API call
      // final newGoal = await _apiService.createSavingsGoal(goal);
      _goals.add(goal);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding goal: $e');
      return false;
    }
  }

  Future<bool> updateGoal(SavingsGoal goal) async {
    try {
      // TODO: Replace with actual API call
      // await _apiService.updateSavingsGoal(goal);
      final index = _goals.indexWhere((g) => g.id == goal.id);
      if (index != -1) {
        _goals[index] = goal;
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error updating goal: $e');
      return false;
    }
  }

  Future<bool> deleteGoal(String goalId) async {
    try {
      // TODO: Replace with actual API call
      // await _apiService.deleteSavingsGoal(goalId);
      _goals.removeWhere((g) => g.id == goalId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting goal: $e');
      return false;
    }
  }

  List<SavingsGoal> _getMockGoals() {
    return [
      SavingsGoal(
        id: '1',
        name: 'Emergency Fund',
        targetAmount: 10000,
        currentAmount: 6500,
        deadline: DateTime(2025, 12, 31),
        description: 'Build an emergency fund for unexpected expenses',
        isActive: true,
        userId: 'user1',
      ),
      SavingsGoal(
        id: '2',
        name: 'Vacation',
        targetAmount: 3000,
        currentAmount: 1200,
        deadline: DateTime(2025, 6, 15),
        description: 'Save for summer vacation to Europe',
        isActive: true,
        userId: 'user1',
      ),
      SavingsGoal(
        id: '3',
        name: 'New Car',
        targetAmount: 25000,
        currentAmount: 8500,
        deadline: DateTime(2026, 3, 1),
        description: 'Save for a new car down payment',
        isActive: true,
        userId: 'user1',
      ),
    ];
  }
}
