import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/common/transaction_row.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredTransactions = _filterTransactions(provider.transactions);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterChips(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    return TransactionRow(
                      transaction: filteredTransactions[index],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Income', 'Expense', 'Tax', 'Taxable'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    switch (_selectedFilter) {
      case 'Income':
        return transactions
            .where((t) => t.type == TransactionType.income)
            .toList();
      case 'Expense':
        return transactions
            .where((t) => t.type == TransactionType.expense)
            .toList();
      case 'Tax':
        return transactions
            .where((t) => t.type == TransactionType.tax)
            .toList();
      case 'Taxable':
        return transactions.where((t) => t.isTaxable).toList();
      default:
        return transactions;
    }
  }
}
