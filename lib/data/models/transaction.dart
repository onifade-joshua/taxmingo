import 'package:flutter/material.dart';

enum TransactionType { income, expense, tax }

class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final bool isTaxable;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.isTaxable = false,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      type: TransactionType.values.byName(json['type']),
      category: json['category'],
      isTaxable: json['isTaxable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name,
      'category': category,
      'isTaxable': isTaxable,
    };
  }

  Color get typeColor {
    switch (type) {
      case TransactionType.income:
        return Colors.green;
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.tax:
        return Colors.orange;
    }
  }

  IconData get typeIcon {
    switch (type) {
      case TransactionType.income:
        return Icons.arrow_upward;
      case TransactionType.expense:
        return Icons.arrow_downward;
      case TransactionType.tax:
        return Icons.receipt_long;
    }
  }
}
