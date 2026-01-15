class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);
}

class DateRangeHelper {
  static DateRange week(DateTime date) {
    final start = date.subtract(Duration(days: date.weekday - 1));
    final end = start.add(const Duration(days: 6));
    return DateRange(start, end);
  }

  static DateRange month(DateTime date) {
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0);
    return DateRange(start, end);
  }

  static DateRange year(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    final end = DateTime(date.year, 12, 31);
    return DateRange(start, end);
  }
}
