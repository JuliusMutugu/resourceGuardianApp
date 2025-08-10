import 'package:dio/dio.dart';
import '../models/dashboard_data.dart';
import '../models/transaction.dart';
import '../models/savings_goal.dart';

class ApiService {
  late final Dio _dio;
  static const String baseUrl = 'http://localhost:8080/api'; // Your Spring Boot backend URL

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    // Add interceptors
    _dio.interceptors.add(LogInterceptor());
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token to requests
        // TODO: Get token from AuthProvider
        // options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle errors globally
        print('API Error: ${e.message}');
        handler.next(e);
      },
    ));
  }

  // Dashboard endpoints
  Future<DashboardData> getDashboardData() async {
    try {
      final response = await _dio.get('/dashboard');
      return DashboardData.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load dashboard data: $e');
    }
  }

  // Transaction endpoints
  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await _dio.get('/transactions');
      return (response.data as List)
          .map((json) => Transaction.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  Future<Transaction> createTransaction(Transaction transaction) async {
    try {
      final response = await _dio.post('/transactions', data: transaction.toJson());
      return Transaction.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    try {
      final response = await _dio.put('/transactions/${transaction.id}', data: transaction.toJson());
      return Transaction.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _dio.delete('/transactions/$transactionId');
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  // Savings Goal endpoints
  Future<List<SavingsGoal>> getSavingsGoals() async {
    try {
      final response = await _dio.get('/savings-goals');
      return (response.data as List)
          .map((json) => SavingsGoal.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load savings goals: $e');
    }
  }

  Future<SavingsGoal> createSavingsGoal(SavingsGoal goal) async {
    try {
      final response = await _dio.post('/savings-goals', data: goal.toJson());
      return SavingsGoal.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create savings goal: $e');
    }
  }

  Future<SavingsGoal> updateSavingsGoal(SavingsGoal goal) async {
    try {
      final response = await _dio.put('/savings-goals/${goal.id}', data: goal.toJson());
      return SavingsGoal.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update savings goal: $e');
    }
  }

  Future<void> deleteSavingsGoal(String goalId) async {
    try {
      await _dio.delete('/savings-goals/$goalId');
    } catch (e) {
      throw Exception('Failed to delete savings goal: $e');
    }
  }
}
