class TaxReport {
  final String id;
  final String name;
  final DateTime period;
  final double totalIncome;
  final double totalDeductions;
  final double taxableIncome;
  final double taxOwed;
  final String status;
  final DateTime createdAt;

  TaxReport({
    required this.id,
    required this.name,
    required this.period,
    required this.totalIncome,
    required this.totalDeductions,
    required this.taxableIncome,
    required this.taxOwed,
    required this.status,
    required this.createdAt,
  });

  factory TaxReport.fromJson(Map<String, dynamic> json) {
    return TaxReport(
      id: json['id'],
      name: json['name'],
      period: DateTime.parse(json['period']),
      totalIncome: json['totalIncome'].toDouble(),
      totalDeductions: json['totalDeductions'].toDouble(),
      taxableIncome: json['taxableIncome'].toDouble(),
      taxOwed: json['taxOwed'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'period': period.toIso8601String(),
      'totalIncome': totalIncome,
      'totalDeductions': totalDeductions,
      'taxableIncome': taxableIncome,
      'taxOwed': taxOwed,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
