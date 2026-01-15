// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendlite/app_shell.dart';

import 'core/theme/app_theme.dart';
import 'features/budget/model/monthly_budget.dart';
import 'features/transactions/model/expense_model.dart';
// import your main screen/navigation

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Hive
  await Hive.initFlutter();

  // ✅ Register Adapters (before opening boxes)
  Hive.registerAdapter(MonthlyBudgetAdapter());
  Hive.registerAdapter(ExpenseAdapter());

  // ✅ Open ALL boxes before running app
  await Hive.openBox<MonthlyBudget>('budgets');
  await Hive.openBox<Expense>('expenses');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendLite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppShell(), // Your main screen with bottom nav
    );
  }
}