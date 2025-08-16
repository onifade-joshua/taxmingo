import 'package:flutter/material.dart';
import '../../data/models/tax_report.dart';

class TaxProvider with ChangeNotifier {
  List<TaxReport> _reports = [];
  bool _isLoading = false;

  List<TaxReport> get reports => _reports;
  bool get isLoading => _isLoading;

  double get totalTaxOwed {
    return _reports.fold(0, (sum, report) => sum + report.taxOwed);
  }

  double get totalTaxableIncome {
    return _reports.fold(0, (sum, report) => sum + report.taxableIncome);
  }

  void loadReports() {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      _reports = [
        TaxReport(
          id: '1',
          name: 'Q1 2024 Tax Report',
          period: DateTime(2024, 3, 31),
          totalIncome: 2500000,
          totalDeductions: 300000,
          taxableIncome: 2200000,
          taxOwed: 440000,
          status: 'Filed',
          createdAt: DateTime.now(),
        ),
        TaxReport(
          id: '2',
          name: 'Q2 2024 Tax Report',
          period: DateTime(2024, 6, 30),
          totalIncome: 2800000,
          totalDeductions: 350000,
          taxableIncome: 2450000,
          taxOwed: 490000,
          status: 'Pending',
          createdAt: DateTime.now(),
        ),
      ];
      _isLoading = false;
      notifyListeners();
    });
  }
}
