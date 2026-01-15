import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DailyBarChart extends StatelessWidget {
  final Map<DateTime, double> data;

  const DailyBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text(
        'No data',
        style: TextStyle(color: AppColors.mutedText),
      );
    }

    final entries = data.entries.toList();

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          barGroups: List.generate(entries.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entries[index].value,
                  width: 14,
                )
              ],
            );
          }),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
