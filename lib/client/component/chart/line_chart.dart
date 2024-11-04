import 'package:budgetman/server/component/extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomLineChart<T extends Comparable> extends StatefulWidget {
  const CustomLineChart({
    super.key,
    required this.data,
    this.maxY,
    this.minY,
    this.leftAxisTitleWidget,
    this.bottomAxisTitleWidget,
    this.getLeftAxisTitlesWidget,
    this.getBottomAxisTitlesWidget,
    this.getTooltipItems,
  });

  final List<FlSpot> data;
  final double? maxY;
  final double? minY;
  final Widget? leftAxisTitleWidget;
  final Widget? bottomAxisTitleWidget;
  final Widget Function(double, TitleMeta)? getLeftAxisTitlesWidget;
  final Widget Function(double, TitleMeta)? getBottomAxisTitlesWidget;
  final List<LineTooltipItem> Function(List<FlSpot>)? getTooltipItems;

  @override
  State<CustomLineChart> createState() => CustomLineChartState();
}

class CustomLineChartState extends State<CustomLineChart> {
  @override
  Widget build(BuildContext context) {
    final gradientColors = [
      context.theme.colorScheme.tertiary,
      context.theme.colorScheme.tertiary.withOpacity(.3),
    ];
    final realMaxY =
        widget.maxY?.clamp(1.0, double.maxFinite) ?? widget.data.map((e) => e.y).max.toDouble();
    final realMinY = widget.minY?.clamp(1.0, double.maxFinite) ?? 0;
    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        right: 48.0,
      ),
      child: LineChart(
        LineChartData(
          maxY: realMaxY,
          minY: realMinY,
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) {
                return context.theme.colorScheme.onTertiary;
              },
              getTooltipItems: widget.getTooltipItems ?? defaultLineTooltipItem,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: widget.data,
              isCurved: true,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              barWidth: 2,
              curveSmoothness: 1 / widget.data.length,
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
              axisNameWidget: widget.leftAxisTitleWidget,
              sideTitles: SideTitles(
                showTitles: true,
                maxIncluded: false,
                interval: () {
                  double result = widget.data.map((e) => e.y).max.toDouble() / 3;
                  return result == 0 ? 1.0 : result;
                }(),
                getTitlesWidget: widget.getLeftAxisTitlesWidget ?? defaultGetTitle,
                reservedSize: 62,
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: widget.bottomAxisTitleWidget,
              sideTitles: SideTitles(
                showTitles: true,
                minIncluded: false,
                maxIncluded: false,
                interval: () {
                  double result = widget.data.map((e) => e.x).max.toDouble() / 3;
                  return result == 0 ? 1.0 : result;
                }(),
                getTitlesWidget: widget.getBottomAxisTitlesWidget ?? defaultGetTitle,
              ),
            ),
          ),
        ),
        curve: Curves.easeInOutCubicEmphasized,
        duration: 700.milliseconds,
      ),
    );
  }
}
