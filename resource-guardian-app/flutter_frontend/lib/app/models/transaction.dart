import 'package:intl/intl.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final double amount;
  final String description;
  final String category;
  final TransactionType type;
  final DateTime date;
  final String userId;

  Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.type,
    required this.date,
    required this.userId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'].toDouble(),
      description: json['description'],
      category: json['category'],
      type: json['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      date: DateTime.parse(json['date']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'category': category,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'date': date.toIso8601String(),
      'userId': userId,
    };
  }

  String get formattedAmount {
    final formatter = NumberFormat.currency(symbol: '\$');
    return formatter.format(amount);
  }

  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
}
