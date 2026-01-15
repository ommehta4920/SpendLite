import 'package:hive/hive.dart';
part 'monthly_budget.g.dart';

@HiveType(typeId: 1)
class MonthlyBudget extends HiveObject {
  @HiveField(0)
  int year;

  @HiveField(1)
  int month;

  @HiveField(2)
  double limit;

  MonthlyBudget({
    required this.year,
    required this.month,
    required this.limit,
  });
}
