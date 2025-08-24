import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/savings_goal.dart';
import 'api_config.dart';

class GoalsApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    headers: ApiConfig.headers,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  static Future<List<SavingsGoal>> fetchGoals(String token) async {
    try {
      final response = await _dio.get(
        ApiConfig.savingsGoalsEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> goalsData = data['content'] ?? data;
        return goalsData.map((json) => SavingsGoal.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch goals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching goals: $e');
    }
  }

  static Future<List<SavingsGoal>> fetchActiveGoals(String token) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.savingsGoalsEndpoint}/active',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> goalsData = response.data;
        return goalsData.map((json) => SavingsGoal.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch active goals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching active goals: $e');
    }
  }

  static Future<List<SavingsGoal>> fetchCompletedGoals(String token) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.savingsGoalsEndpoint}/completed',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> goalsData = response.data;
        return goalsData.map((json) => SavingsGoal.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch completed goals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching completed goals: $e');
    }
  }

  static Future<SavingsGoal> createGoal(String token, SavingsGoal goal) async {
    try {
      final response = await _dio.post(
        ApiConfig.savingsGoalsEndpoint,
        data: goal.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SavingsGoal.fromJson(response.data);
      } else {
        throw Exception('Failed to create goal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating goal: $e');
    }
  }

  static Future<SavingsGoal> updateGoal(
      String token, int goalId, SavingsGoal goal) async {
    try {
      final response = await _dio.put(
        '${ApiConfig.savingsGoalsEndpoint}/$goalId',
        data: goal.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return SavingsGoal.fromJson(response.data);
      } else {
        throw Exception('Failed to update goal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating goal: $e');
    }
  }

  static Future<void> deleteGoal(String token, int goalId) async {
    try {
      final response = await _dio.delete(
        '${ApiConfig.savingsGoalsEndpoint}/$goalId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete goal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting goal: $e');
    }
  }

  static Future<SavingsGoal> addToGoal(
      String token, int goalId, double amount) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.savingsGoalsEndpoint}/$goalId/add',
        data: {'amount': amount},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return SavingsGoal.fromJson(response.data);
      } else {
        throw Exception('Failed to add to goal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding to goal: $e');
    }
  }

  static Future<SavingsGoal> withdrawFromGoal(
      String token, int goalId, double amount) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.savingsGoalsEndpoint}/$goalId/withdraw',
        data: {'amount': amount},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return SavingsGoal.fromJson(response.data);
      } else {
        throw Exception('Failed to withdraw from goal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error withdrawing from goal: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchGoalStatistics(String token) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.savingsGoalsEndpoint}/statistics',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch goal statistics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching goal statistics: $e');
    }
  }
}
