import 'package:flutter/material.dart';

class ExpenseCategory {
  final String name;
  final IconData icon;

  ExpenseCategory(this.name, this.icon);
}

final categories = [
  ExpenseCategory('Food', Icons.fastfood),
  ExpenseCategory('Transport', Icons.directions_car),
  ExpenseCategory('Shopping', Icons.shopping_bag),
  ExpenseCategory('Bills', Icons.receipt),
  ExpenseCategory('Entertainment', Icons.movie),
  ExpenseCategory('Other', Icons.category),
];
