// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/budget_card.dart';
import '../analytics/ui/daily_summary_card.dart';
import '../transactions/ui/expense_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Budgets'),
        centerTitle: true,  // ✅ Added to match ManageScreen
        backgroundColor: AppColors.background,
        elevation: 0,
        // Optional: Add these for consistent styling
        titleTextStyle: const TextStyle(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          DailySummaryCard(),
          SizedBox(height: 16),

          BudgetCard(),
          SizedBox(height: 24),

          Text(
            'Recent Expenses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),

          ExpenseList(limit: 5),
        ],
      ),
    );
  }
}