// lib/widgets/budget_card.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/theme/app_colors.dart';
import '../features/budget/logic/budget_helper.dart';
import '../features/budget/model/monthly_budget.dart';
import '../features/transactions/model/expense_model.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 👇 Listen to BOTH budget AND expense changes
    return ValueListenableBuilder<Box<MonthlyBudget>>(
      valueListenable: BudgetHelper.budgetListenable,
      builder: (context, budgetBox, _) {
        return ValueListenableBuilder<Box<Expense>>(
          valueListenable: BudgetHelper.expenseListenable,
          builder: (context, expenseBox, _) {
            final budget = BudgetHelper.getCurrentBudget();
            final spent = BudgetHelper.getSpentThisMonth();

            if (budget == null) {
              return _buildNoBudgetCard(context);
            }

            return _buildBudgetCard(context, budget, spent);
          },
        );
      },
    );
  }

  Widget _buildNoBudgetCard(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.account_balance_wallet, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'No budget set for this month',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showSetBudgetDialog(context),
              child: const Text('Set Budget'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetCard(BuildContext context, MonthlyBudget budget, double spent) {
    final remaining = budget.limit - spent;
    final progress = budget.limit > 0 ? (spent / budget.limit).clamp(0.0, 1.0) : 0.0;
    final isOverBudget = spent > budget.limit;

    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getMonthName(budget.month),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showSetBudgetDialog(context, currentLimit: budget.limit),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation(
                  isOverBudget ? Colors.red : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Amounts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAmount('Spent', spent, isOverBudget ? Colors.red : null),
                _buildAmount('Budget', budget.limit, null),
                _buildAmount(
                  'Remaining',
                  remaining.abs(),
                  isOverBudget ? Colors.red : Colors.green,
                  prefix: isOverBudget ? '-' : '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmount(String label, double amount, Color? color, {String prefix = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
        Text(
          '$prefix\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  void _showSetBudgetDialog(BuildContext context, {double? currentLimit}) {
    final controller = TextEditingController(
      text: currentLimit?.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(currentLimit == null ? 'Set Budget' : 'Edit Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Monthly Limit',
            prefixText: '\$ ',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final limit = double.tryParse(controller.text);
              if (limit != null && limit > 0) {
                BudgetHelper.setBudget(limit);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}