// budget_deadline_graph.dart
import 'package:flutter/material.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class BudgetDeadlineGraph extends StatelessWidget {
  final List<BudgetList> transactions;

  const BudgetDeadlineGraph({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No Data Available',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    // Prepare data for the graph
    final dataPoints = transactions.map((transaction) {
      final xValue = transaction.deadline.difference(DateTime(1970, 1, 1)).inDays.toDouble();
      final yValue = transaction.budget;
      return FlSpot(xValue, yValue);
    }).toList();
    dataPoints.sort((a, b) => a.x.compareTo(b.x));
    final minX = dataPoints.first.x;
    final maxX = dataPoints.last.x;
    final minY = dataPoints.map((e) => e.y).reduce(min);
    final maxY = dataPoints.map((e) => e.y).reduce(max);
    const numIntervals = 4;
    final yInterval = ((maxY - minY) / numIntervals).ceilToDouble();
    final xInterval = ((maxX - minX) / numIntervals).ceilToDouble();
    final adjustedMinY = (minY / yInterval).floor() * yInterval;
    final adjustedMaxY = (maxY / yInterval).ceil() * yInterval;

    // Create line segments with colors based on slope
    List<LineChartBarData> lineBarsData = [];

    for (int i = 0; i < dataPoints.length - 1; i++) {
      final currentPoint = dataPoints[i];
      final nextPoint = dataPoints[i + 1];

      final isRising = nextPoint.y >= currentPoint.y;
      final lineColor = isRising ? Colors.green : Colors.red;

      final barData = LineChartBarData(
        spots: [currentPoint, nextPoint],
        isCurved: false,
        barWidth: 3,
        color: lineColor,
        dotData: FlDotData(show: false),
      );

      lineBarsData.add(barData);
    }

    // Add dots to the chart
    final dotBarData = LineChartBarData(
      spots: dataPoints,
      isCurved: false,
      barWidth: 0,
      color: Colors.transparent,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: Colors.blue,
            strokeWidth: 1.5,
            strokeColor: Colors.white,
          );
        },
      ),
    );

    lineBarsData.add(dotBarData);

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: adjustedMinY,
        maxY: adjustedMaxY,
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: xInterval,
              getTitlesWidget: (value, meta) {
                final date = DateTime(1970, 1, 1).add(Duration(days: value.toInt()));
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 6,
                  child: Text(
                    DateFormat('dd/MM').format(date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: yInterval,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
          ),
        ),
        lineBarsData: lineBarsData,
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval: yInterval,
          verticalInterval: xInterval,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.5),
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.5),
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (LineBarSpot touchedSpot) => Colors.white,
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              if (touchedSpots.isEmpty) {
                return [];
              }

              // Display the tooltip for the touched spot (จุดแรกที่แตะเท่านั้น)
        return touchedSpots.map((spot) {
          if (spot == touchedSpots.first) {
            final date = DateTime(1970, 1, 1).add(Duration(days: spot.x.toInt()));
            final amount = spot.y;
            final amountText = '${(amount / 1000).toStringAsFixed(0)}K';
            return LineTooltipItem(
              'Deadline: ${DateFormat('dd/MM/yyyy').format(date)}, Amount: $amountText',
              TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold, // Make the text bold
              ),
            );
          } else {
            // Return an empty LineTooltipItem for other spots
            return LineTooltipItem('', TextStyle(color: Colors.transparent));
          }
        }).toList();
            },
          ),
        ),
      ),
    );
  }
}
