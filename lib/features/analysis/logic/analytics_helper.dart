import 'package:hive/hive.dart';
import '../../transactions/model/expense_model.dart';

class AnalyticsHelper {
  static List<Expense> filterByPeriod(
      List<Expense> expenses,
      DateTime from,
      DateTime to,
      ) {
    return expenses
        .where((e) => e.date.isAfter(from) && e.date.isBefore(to))
        .toList();
  }

  static Map<String, double> categoryTotals(List<Expense> expenses) {
    final Map<String, double> data = {};
    for (var e in expenses) {
      data[e.category] = (data[e.category] ?? 0) + e.amount;
    }
    return data;
  }

  static Map<DateTime, double> dailyTotals(List<Expense> expenses) {
    final Map<DateTime, double> data = {};
    for (var e in expenses) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      data[day] = (data[day] ?? 0) + e.amount;
    }
    return data;
  }

  static List<Expense> getAllExpenses() {
    final box = Hive.box<Expense>('expenses');
    return box.values.toList();
  }
}
