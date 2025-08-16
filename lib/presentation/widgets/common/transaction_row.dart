import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/transaction.dart';

class TransactionRow extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionRow({Key? key, required this.transaction, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: transaction.typeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            transaction.typeIcon,
            color: transaction.typeColor,
            size: 20,
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          '${transaction.category} • ${_formatDate(transaction.date)}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₦${_formatAmount(transaction.amount)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaction.typeColor,
                fontSize: 16,
              ),
            ),
            if (transaction.isTaxable)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Taxable',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatAmount(double amount) {
    return amount
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
