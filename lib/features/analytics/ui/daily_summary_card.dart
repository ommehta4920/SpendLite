import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../transactions/model/expense_model.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({super.key});

  double getTodayTotal(Box<Expense> box) {
    final today = DateTime.now();
    return box.values
        .where((e) =>
    e.date.year == today.year &&
        e.date.month == today.month &&
        e.date.day == today.day)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Expense>('expenses').listenable(),
      builder: (context, Box<Expense> box, _) {
        final total = getTodayTotal(box);

        return Card(
          color: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Spending",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.mutedText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
