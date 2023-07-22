import 'package:chart_example/resource/app_colors.dart';
import 'package:chart_example/resource/color_extentions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartCount extends StatefulWidget {
  const BarChartCount({super.key, required this.data});
  final Map<String,dynamic> data;

  @override
  State<BarChartCount> createState() => _BarChartCountState();
}

class _BarChartCountState extends State<BarChartCount> {

  @override
  Widget build(BuildContext context) {
    int maxCount = widget.data.values.toList().map<int>((item) => int.parse(item['count'].toString())).reduce((a, b) => a > b ? a : b);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.itemsBackground,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.transparent,
              tooltipPadding: EdgeInsets.zero,
              tooltipMargin: 8,
              getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                  ) {
                return BarTooltipItem(
                  rod.toY.round().toString(),
                  const TextStyle(
                    color: AppColors.contentColorCyan,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final style = TextStyle(
                    color: AppColors.contentColorBlue.darken(20),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                  String text;
                  if (value.toInt() >= 7) {
                    text = '';
                  } else {
                    text = widget.data.keys.toList()[value.toInt()];
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Text(text, style: style),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: borderData,
          barGroups:
          List.generate(widget.data.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: double.parse(widget.data.values.toList()[index]['count'].toString()),
                  gradient: _barsGradient,
                )
              ],
              showingTooltipIndicators: [0],
            );
          }),
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: (maxCount+maxCount*0.35).toDouble(),
        ),
      ),
    );
  }


  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      AppColors.contentColorBlue.darken(20),
      AppColors.contentColorCyan,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}
