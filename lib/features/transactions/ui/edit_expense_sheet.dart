import 'package:flutter/material.dart';
import '../model/expense_model.dart';
import '../logic/categories.dart'; // Import categories logic
import '../../../core/theme/app_colors.dart'; // Import AppColors

class EditExpenseSheet extends StatefulWidget {
  final Expense expense;

  const EditExpenseSheet({super.key, required this.expense});

  @override
  State<EditExpenseSheet> createState() => _EditExpenseSheetState();
}

class _EditExpenseSheetState extends State<EditExpenseSheet> {
  late TextEditingController amountController;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    // Pre-fill amount
    amountController =
        TextEditingController(text: widget.expense.amount.toString());

    // Pre-fill category.
    // Ensure the current category exists in your list, otherwise default to the first one to avoid crashes.
    final categoryExists = categories.any((c) => c.name == widget.expense.category);
    selectedCategory = categoryExists ? widget.expense.category : categories.first.name;
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void saveChanges() async {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;

    // Update the Hive object directly
    widget.expense.amount = amount;
    widget.expense.category = selectedCategory;

    await widget.expense.save(); // Persist changes

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Matching padding logic from AddExpenseSheet
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
          crossAxisAlignment: CrossAxisAlignment.start, // Align to start
          children: [
            const Text(
              'Edit Expense',
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

            /// Category - Changed from TextField to Dropdown
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

            const SizedBox(height: 16), // Increased spacing slightly for visual balance

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: saveChanges,
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}