import 'package:budgetman/extension.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomLineChart extends StatefulWidget {
  const CustomLineChart({
    super.key,
    required this.data,
  });

  final List<({DateTime x, double y})> data;

  @override
  State<CustomLineChart> createState() => CustomLineChartState();
}

class CustomLineChartState extends State<CustomLineChart> {
  @override
  Widget build(BuildContext context) {
    final sortedData = <DateTime, double>{};
    for (final e in widget.data) {
      final key = e.x;
      if (sortedData.containsKey(key)) {
        sortedData[key] = sortedData[key]! + e.y;
      } else {
        sortedData[key] = e.y;
      }
    }
    final firstDateTime = sortedData.keys.first;
    final gradientColors = [
      context.theme.colorScheme.tertiary,
      context.theme.colorScheme.tertiary.withOpacity(0.3),
    ];

    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        right: 48.0,
      ),
      child: LineChart(
        LineChartData(
          maxY: sortedData.values.max * 1.5,
          minY: sortedData.values.min * 0.5,
          lineBarsData: [
            LineChartBarData(
              spots: sortedData.entries
                  .map((e) => FlSpot(
                      e.key.difference(firstDateTime).inDays.toDouble(), e.value.roundToDouble()))
                  .toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors.toList(),
                ),
              ),
            ),
          ],
          borderData: FlBorderData(
            show: false,
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text('Amount'),
              sideTitles: SideTitles(
                showTitles: true,
                interval: sortedData.values.mean.toDouble(),
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      value.toShortString(fractionDigits: 0),
                    ),
                  );
                },
                reservedSize: 42,
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text('Date Time'),
              sideTitles: SideTitles(
                showTitles: true,
                interval: sortedData.keys.length / 3,
                getTitlesWidget: (value, meta) {
                  final date = firstDateTime.add(Duration(days: value.toInt()));
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Text(
                      DateFormat('dd/MM/y').format(date),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
