// lib/features/budget/data/budget_helper.dart
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../transactions/model/expense_model.dart';
import '../model/monthly_budget.dart';

class BudgetHelper {
  static Box<MonthlyBudget> get _budgetBox => Hive.box<MonthlyBudget>('budgets');
  static Box<Expense> get _expenseBox => Hive.box<Expense>('expenses');

  // ✅ Add listenable for budget changes
  static ValueListenable<Box<MonthlyBudget>> get budgetListenable =>
      _budgetBox.listenable();

  // ✅ Add listenable for expense changes
  static ValueListenable<Box<Expense>> get expenseListenable =>
      _expenseBox.listenable();

  static MonthlyBudget? getCurrentBudget() {
    final now = DateTime.now();

    try {
      return _budgetBox.values.firstWhere(
            (b) => b.year == now.year && b.month == now.month,
      );
    } catch (_) {
      return null;
    }
  }

  static double getSpentThisMonth() {
    final now = DateTime.now();

    return _expenseBox.values
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  // ✅ Add method to set/update budget
  static Future<void> setBudget(double limit) async {
    final now = DateTime.now();
    final existing = getCurrentBudget();

    if (existing != null) {
      existing.limit = limit;
      await existing.save();
    } else {
      final budget = MonthlyBudget(
        year: now.year,
        month: now.month,
        limit: limit,
      );
      await _budgetBox.add(budget);
    }
  }

  // ✅ Get last N expenses
  static List<Expense> getRecentExpenses(int count) {
    final list = _expenseBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return list.take(count).toList();
  }
}