  import 'package:flutter/material.dart';
  import 'core/theme/app_colors.dart';

  import 'features/home/home_screen.dart';
  import 'features/analysis/analysis_screen.dart';
  import 'features/manage/manage_screen.dart';
  import 'features/more/more_screen.dart';
  import 'features/transactions/ui/add_expense_sheet.dart';

  class AppShell extends StatefulWidget {
    const AppShell({super.key});

    @override
    State<AppShell> createState() => _AppShellState();
  }

  class _AppShellState extends State<AppShell> {
    int _currentIndex = 0;

    final screens = const [
      HomeScreen(),
      AnalysisScreen(),
      ManageScreen(),
      MoreScreen(),
    ];

    void _onFabPressed() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => const AddExpenseSheet(),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        // 1. Explicitly make the FAB round
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
          onPressed: _onFabPressed,
          child: const Icon(Icons.add, color: Colors.black),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // 2. Switched to BottomAppBar to allow spacing in the middle
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(), // Creates the curve for the FAB
          notchMargin: 8.0, // Margin between FAB and the bar
          color: AppColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 60, // Standard height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavItem(0, Icons.home, 'Home'),
                  _buildNavItem(1, Icons.bar_chart, 'Analysis'),
                ],
              ),

              // Right side icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavItem(2, Icons.manage_accounts, 'Manage'),
                  _buildNavItem(3, Icons.more_horiz, 'More'),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Helper widget to build navigation items similar to BottomNavigationBar
    Widget _buildNavItem(int index, IconData icon, String label) {
      final isSelected = _currentIndex == index;
      final color = isSelected ? Colors.white : AppColors.mutedText;

      return MaterialButton(
        minWidth: 40, // Reduces default button padding to fit better
        onPressed: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12, // Standard nav bar label size
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }
  }