// lib/features/manage/manage_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/services/pdf_service.dart';
import '../../core/utils/toast_service.dart';
import '../transactions/model/expense_model.dart';
import '../transactions/ui/edit_expense_sheet.dart';
import '../budget/model/monthly_budget.dart';
import '../budget/ui/set_budget_sheet.dart';

class ManageScreen extends StatelessWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Budget',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          const _EditBudgetCard(),

          const SizedBox(height: 32),

          // Transaction Header + PDF Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),

              // ✅ Download Button with withAlpha()
              InkWell(
                onTap: () => _downloadReport(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    // 0.1 opacity * 255 ≈ 26
                    color: AppColors.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                    // 0.5 opacity * 255 ≈ 128
                    border: Border.all(color: AppColors.primary.withAlpha(128)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.download, size: 16, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text(
                        'PDF',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const _TransactionList(),
        ],
      ),
    );
  }

  void _downloadReport(BuildContext context) async {
    final box = Hive.box<Expense>('expenses');

    if (box.isEmpty) {
      ToastService.show(context, 'No transactions to export', isError: true);
      return;
    }

    try {
      final expenses = box.values.toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      await PdfService.generateTransactionReport(expenses);
    } catch (e) {
      ToastService.show(context, 'Failed to generate PDF', isError: true);
    }
  }
}

/* ------------------ EDIT BUDGET (Unchanged) ------------------ */

class _EditBudgetCard extends StatelessWidget {
  const _EditBudgetCard();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MonthlyBudget>('budgets').listenable(),
      builder: (context, box, _) {
        final now = DateTime.now();

        MonthlyBudget? budget;
        try {
          budget = box.values.firstWhere(
                (b) => b.year == now.year && b.month == now.month,
          );
        } catch (_) {
          budget = null;
        }

        final currentLimit = budget?.limit ?? 0;

        return Card(
          color: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            title: const Text(
              'Monthly Budget',
              style: TextStyle(color: AppColors.text),
            ),
            subtitle: Text(
              currentLimit > 0
                  ? '\$${currentLimit.toStringAsFixed(2)}'
                  : 'No budget set',
              style: const TextStyle(color: AppColors.mutedText),
            ),
            trailing: const Icon(Icons.edit, color: AppColors.primary),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: AppColors.card,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => const SetBudgetSheet(),
              );
            },
          ),
        );
      },
    );
  }
}

/* ---------------- TRANSACTIONS (Unchanged) ---------------- */

class _TransactionList extends StatelessWidget {
  const _TransactionList();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Expense>('expenses').listenable(),
      builder: (context, box, _) {
        final expenses = box.values.toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        // No need to reverse since we sorted descending above
        // final reversedExpenses = expenses.reversed.toList();

        if (expenses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(color: AppColors.mutedText),
              ),
            ),
          );
        }

        return Column(
          children: expenses.map((expense) {
            return Card(
              color: AppColors.card,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  expense.category,
                  style: const TextStyle(color: AppColors.text),
                ),
                subtitle: Text(
                  '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                  style: const TextStyle(color: AppColors.mutedText),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: AppColors.mutedText),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: AppColors.card,
                      useSafeArea: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (_) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: EditExpenseSheet(expense: expense),
                      ),
                    );
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${expense.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(context, expense),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Expense expense) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delete Transaction',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text),
            ),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to delete this transaction? This action cannot be undone.',
              style: TextStyle(fontSize: 16, color: AppColors.mutedText),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  expense.delete();
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.mutedText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}