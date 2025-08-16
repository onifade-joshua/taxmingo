import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../providers/tax_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/common/transaction_row.dart';
import '../transactions/transactions_page.dart';
import '../reports/reports_page.dart';
import '../profile/profile_page.dart'; // <-- Make sure you import ProfilePage

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaxProvider>().loadReports();
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboardContent(),
      const TransactionsPage(),
      const ReportsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nigerian Tax Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Reports',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                _showAddTransactionDialog();
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildDashboardContent() {
    return Consumer2<TaxProvider, TransactionProvider>(
      builder: (context, taxProvider, transactionProvider, child) {
        if (taxProvider.isLoading || transactionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 20),
              _buildStatsGrid(transactionProvider, taxProvider),
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 20),
              _buildRecentTransactions(transactionProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your Nigerian tax obligations with ease',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    TransactionProvider transactionProvider,
    TaxProvider taxProvider,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
        final childAspectRatio = constraints.maxWidth < 600 ? 1.0 : 1.1;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            StatCard(
              title: 'Total Income',
              value: '₦${_formatAmount(transactionProvider.totalIncome)}',
              icon: Icons.trending_up,
              color: AppColors.success,
              subtitle: 'This month',
            ),
            StatCard(
              title: 'Total Expenses',
              value: '₦${_formatAmount(transactionProvider.totalExpenses)}',
              icon: Icons.trending_down,
              color: AppColors.error,
              subtitle: 'This month',
            ),
            StatCard(
              title: 'Taxable Income',
              value:
                  '₦${_formatAmount(transactionProvider.totalTaxableIncome)}',
              icon: Icons.account_balance_wallet,
              color: AppColors.warning,
              subtitle: 'Subject to tax',
            ),
            StatCard(
              title: 'Tax Owed',
              value: '₦${_formatAmount(taxProvider.totalTaxOwed)}',
              icon: Icons.receipt_long,
              color: AppColors.primary,
              subtitle: 'Total outstanding',
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Add Transaction',
                icon: Icons.add_circle_outline,
                onTap: _showAddTransactionDialog,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                title: 'Generate Report',
                icon: Icons.description_outlined,
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(TransactionProvider provider) {
    final recentTransactions = provider.transactions.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentTransactions.length,
          itemBuilder: (context, index) {
            return TransactionRow(transaction: recentTransactions[index]);
          },
        ),
      ],
    );
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddTransactionDialog(),
    );
  }

  String _formatAmount(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
