// lib/features/analytics/analysis_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../transactions/model/expense_model.dart';
import 'logic/period_type.dart';
import 'ui/category_pie_chart.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  PeriodType selectedPeriod = PeriodType.month;

  // ---------------- FILTER LOGIC ----------------
  List<Expense> _filterExpenses(List<Expense> expenses) {
    final now = DateTime.now();

    return expenses.where((e) {
      if (selectedPeriod == PeriodType.year) {
        return e.date.year == now.year;
      }
      if (selectedPeriod == PeriodType.month) {
        return e.date.year == now.year && e.date.month == now.month;
      }
      // Day
      return e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day;
    }).toList();
  }

  double _totalAmount(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  Map<String, double> _categoryTotals(List<Expense> expenses) {
    final Map<String, double> data = {};
    for (final e in expenses) {
      data[e.category] = (data[e.category] ?? 0) + e.amount;
    }
    return data;
  }

  String _getPeriodLabel() {
    final now = DateTime.now();
    switch (selectedPeriod) {
      case PeriodType.day:
        return 'Today';
      case PeriodType.month:
        return _getMonthName(now.month);
      case PeriodType.year:
        return '${now.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Analysis'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Expense>('expenses').listenable(),
        builder: (context, box, _) {
          final allExpenses = box.values.toList();
          final filtered = _filterExpenses(allExpenses);
          final total = _totalAmount(filtered);
          final categoryData = _categoryTotals(filtered);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // PERIOD SELECTOR
              _buildPeriodSelector(),

              const SizedBox(height: 16),

              // TOTAL SPENT CARD
              _buildTotalCard(total, filtered.length),

              const SizedBox(height: 24),

              // CATEGORY BREAKDOWN
              if (allExpenses.isEmpty)
                _buildEmptyState()
              else if (categoryData.isEmpty)
                _buildNoDataForPeriod()
              else ...[
                  const Text(
                    'Spending by Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pie Chart
                  CategoryPieChart(data: categoryData),

                  const SizedBox(height: 24),

                  // Category List
                  _buildCategoryList(categoryData, total),
                ],
            ],
          );
        },
      ),
    );
  }

  // ---------------- PERIOD SELECTOR ----------------
  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildPeriodButton('Day', PeriodType.day),
          _buildPeriodButton('Month', PeriodType.month),
          _buildPeriodButton('Year', PeriodType.year),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String label, PeriodType type) {
    final isSelected = selectedPeriod == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedPeriod = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.mutedText,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- TOTAL CARD ----------------
  Widget _buildTotalCard(double total, int transactionCount) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getPeriodLabel(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Total Spent',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- CATEGORY LIST ----------------
  Widget _buildCategoryList(Map<String, double> categoryData, double total) {
    // Sort by amount descending
    final sortedEntries = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: sortedEntries.map((entry) {
            final percentage = total > 0 ? (entry.value / total * 100) : 0.0;
            return _buildCategoryTile(
              entry.key,
              entry.value,
              percentage,
              _getCategoryColor(sortedEntries.indexOf(entry)),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
      String category,
      double amount,
      double percentage,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              // Color indicator
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              // Category name
              Expanded(
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
              ),

              // Amount and percentage
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 6,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- EMPTY STATES ----------------
  Widget _buildEmptyState() {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 64,
              color: AppColors.mutedText,
            ),
            SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mutedText,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add expenses to see your spending analysis',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.mutedText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataForPeriod() {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 64,
              color: AppColors.mutedText,
            ),
            const SizedBox(height: 16),
            Text(
              'No expenses for ${_getPeriodLabel().toLowerCase()}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try selecting a different time period',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.mutedText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- COLORS ----------------
  Color _getCategoryColor(int index) {
    const colors = [
      Color(0xFF22C55E), // Green
      Color(0xFF3B82F6), // Blue
      Color(0xFFF59E0B), // Amber
      Color(0xFFEF4444), // Red
      Color(0xFF8B5CF6), // Purple
      Color(0xFF06B6D4), // Cyan
      Color(0xFFEC4899), // Pink
      Color(0xFF84CC16), // Lime
      Color(0xFFF97316), // Orange
      Color(0xFF6366F1), // Indigo
    ];
    return colors[index % colors.length];
  }
}