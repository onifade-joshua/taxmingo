import 'package:flutter/material.dart';
import '../../data/models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get totalTaxableIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income && t.isTaxable)
        .fold(0, (sum, t) => sum + t.amount);
  }

  void loadTransactions() {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      _transactions = [
        Transaction(
          id: '1',
          description: 'Salary Payment',
          amount: 850000,
          date: DateTime.now().subtract(const Duration(days: 5)),
          type: TransactionType.income,
          category: 'Salary',
          isTaxable: true,
        ),
        Transaction(
          id: '2',
          description: 'Office Rent',
          amount: 120000,
          date: DateTime.now().subtract(const Duration(days: 3)),
          type: TransactionType.expense,
          category: 'Rent',
          isTaxable: false,
        ),
        Transaction(
          id: '3',
          description: 'Consulting Fee',
          amount: 300000,
          date: DateTime.now().subtract(const Duration(days: 1)),
          type: TransactionType.income,
          category: 'Consulting',
          isTaxable: true,
        ),
        Transaction(
          id: '4',
          description: 'PAYE Tax',
          amount: 85000,
          date: DateTime.now(),
          type: TransactionType.tax,
          category: 'Tax',
          isTaxable: false,
        ),
      ];
      _isLoading = false;
      notifyListeners();
    });
  }

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }
}
