import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

import '../../../core/theme/app_colors.dart';
import '../model/expense_model.dart';
import '../logic/categories.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final amountController = TextEditingController();
  String selectedCategory = categories.first.name;

  void saveExpense() {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;

    final expense = Expense(
      id: const Uuid().v4(),
      amount: amount,
      category: selectedCategory,
      date: DateTime.now(),
    );

    final box = Hive.box<Expense>('expenses');
    box.add(expense);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            24,
      ),
      child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Expense',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          /// Amount
          TextField(
            autofocus: true,
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: '\$ ',
              hintText: 'Amount',
            ),
          ),

          const SizedBox(height: 16),

          /// Category
          DropdownButtonFormField(
            value: selectedCategory,
            items: categories
                .map(
                  (c) => DropdownMenuItem(
                value: c.name,
                child: Text(c.name),
              ),
            )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: saveExpense,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
