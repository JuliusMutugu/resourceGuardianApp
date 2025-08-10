import 'package:intl/intl.dart';

class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String? description;
  final bool isActive;
  final String userId;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    this.description,
    required this.isActive,
    required this.userId,
  });

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'],
      name: json['name'],
      targetAmount: json['targetAmount'].toDouble(),
      currentAmount: json['currentAmount'].toDouble(),
      deadline: DateTime.parse(json['deadline']),
      description: json['description'],
      isActive: json['isActive'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': deadline.toIso8601String(),
      'description': description,
      'isActive': isActive,
      'userId': userId,
    };
  }

  double get progressPercentage {
    if (targetAmount == 0) return 0;
    return (currentAmount / targetAmount).clamp(0.0, 1.0);
  }

  double get remainingAmount {
    return (targetAmount - currentAmount).clamp(0.0, double.infinity);
  }

  String get formattedCurrentAmount {
    final formatter = NumberFormat.currency(symbol: '\$');
    return formatter.format(currentAmount);
  }

  String get formattedTargetAmount {
    final formatter = NumberFormat.currency(symbol: '\$');
    return formatter.format(targetAmount);
  }

  String get formattedRemainingAmount {
    final formatter = NumberFormat.currency(symbol: '\$');
    return formatter.format(remainingAmount);
  }

  String get formattedDeadline {
    return DateFormat('MMM dd, yyyy').format(deadline);
  }

  bool get isCompleted => currentAmount >= targetAmount;

  int get daysRemaining {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    return difference.inDays;
  }

  bool get isOverdue => DateTime.now().isAfter(deadline) && !isCompleted;
}
