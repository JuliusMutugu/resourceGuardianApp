import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';

class TransactionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // For now, using mock data
      _transactions = _getMockTransactions();
      // TODO: Replace with actual API call
      // _transactions = await _apiService.getTransactions();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading transactions: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addTransaction(Transaction transaction) async {
    try {
      // TODO: Replace with actual API call
      // final newTransaction = await _apiService.createTransaction(transaction);
      _transactions.insert(0, transaction);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      return false;
    }
  }

  Future<bool> updateTransaction(Transaction transaction) async {
    try {
      // TODO: Replace with actual API call
      // await _apiService.updateTransaction(transaction);
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      return false;
    }
  }

  Future<bool> deleteTransaction(String transactionId) async {
    try {
      // TODO: Replace with actual API call
      // await _apiService.deleteTransaction(transactionId);
      _transactions.removeWhere((t) => t.id == transactionId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      return false;
    }
  }

  List<Transaction> _getMockTransactions() {
    return [
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
      Transaction(
        id: '4',
        amount: 45.00,
        description: 'Coffee Shop',
        category: 'Food & Dining',
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(days: 4)),
        userId: 'user1',
      ),
      Transaction(
        id: '5',
        amount: 120.00,
        description: 'Internet Bill',
        category: 'Utilities',
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(days: 5)),
        userId: 'user1',
      ),
    ];
  }
}
