// lib/features/transactions/ui/expense_list.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../budget/logic/budget_helper.dart';
import '../model/expense_model.dart';
import 'expense_tile.dart';

class ExpenseList extends StatelessWidget {
  final int? limit;

  const ExpenseList({super.key, this.limit});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Expense>>(
      valueListenable: BudgetHelper.expenseListenable,
      builder: (context, box, _) {
        var expenses = box.values.toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        if (limit != null && expenses.length > limit!) {
          expenses = expenses.take(limit!).toList();
        }

        if (expenses.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No expenses yet',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: expenses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return ExpenseTile(expense: expenses[index]); // ✅ Works now!
          },
        );
      },
    );
  }
}