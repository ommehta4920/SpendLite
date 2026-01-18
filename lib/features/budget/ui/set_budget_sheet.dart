// lib/features/budget/ui/set_budget_sheet.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../core/theme/app_colors.dart';
import '../model/monthly_budget.dart';
import '../../../core/utils/toast_service.dart';

class SetBudgetSheet extends StatefulWidget {
  final MonthlyBudget? existingBudget;

  const SetBudgetSheet({super.key, this.existingBudget});

  @override
  State<SetBudgetSheet> createState() => _SetBudgetSheetState();
}

class _SetBudgetSheetState extends State<SetBudgetSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.existingBudget?.limit.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingBudget != null && widget.existingBudget!.limit > 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            isEditing ? 'Edit Monthly Budget' : 'Set Monthly Budget',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            isEditing
                ? 'Update your spending limit for this month.'
                : 'Set a spending limit to track your expenses.',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.mutedText,
            ),
          ),
          const SizedBox(height: 24),

          // Budget Input Field
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              labelText: 'Monthly Limit',
              prefixText: '\$ ',
              prefixStyle: const TextStyle(fontSize: 18),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Save Button (Primary Action)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _saveBudget,
              child: Text(
                isEditing ? 'Update Budget' : 'Set Budget',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Cancel Button (Secondary Action)
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
    );
  }

  void _saveBudget() {
    final limit = double.tryParse(_controller.text);

    if (limit == null || limit <= 0) {
      // ✅ NEW: Show error at top
      ToastService.show(context, 'Please enter a valid amount', isError: true);
      return;
    }

    final box = Hive.box<MonthlyBudget>('budgets');
    final now = DateTime.now();

    MonthlyBudget? existing;
    try {
      existing = box.values.firstWhere(
            (b) => b.year == now.year && b.month == now.month,
      );
    } catch (_) {
      existing = null;
    }

    if (existing != null) {
      existing.limit = limit;
      existing.save();
    } else {
      final budget = MonthlyBudget(
        year: now.year,
        month: now.month,
        limit: limit,
      );
      box.add(budget);
    }

    Navigator.pop(context);

    // ✅ NEW: Show success at top
    ToastService.show(
        context,
        existing != null ? 'Budget updated!' : 'Budget set!'
    );
  }
}