import 'package:chart_example/resource/app_colors.dart';
import 'package:chart_example/resource/color_extentions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartRevenue extends StatefulWidget {
  const LineChartRevenue({super.key, required this.data});
  final Map<String,dynamic> data;

  @override
  State<LineChartRevenue> createState() => _LineChartRevenueState();
}

class _LineChartRevenueState extends State<LineChartRevenue> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
  bool showAvg = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: AppColors.itemsBackground,
      decoration: const BoxDecoration(
        color: AppColors.itemsBackground,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                mainData(widget.data),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData(Map<String,dynamic> data) {
    double maxTotalPrice = data.values.toList().map<double>((item) => double.parse(item['totalPrice'].toString())).reduce((a, b) => a > b ? a : b);
    final days = data.keys.toList();
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              final style = TextStyle(
                color: AppColors.contentColorBlue.darken(20),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              Widget text;
              if (value.toInt() >= 7) {
                text = Text('', style: style);
              } else {
                text = Text(data.keys.toList()[value.toInt()], style: style);
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: text,
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              final style = TextStyle(
                color: AppColors.contentColorBlue.darken(20),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              String text;
              switch (value.toInt()) {
                case 1:
                  text = '0';
                  break;
                case 5:
                  text = formatNumber((maxTotalPrice.toInt()/2).round());
                  break;
                case 10:
                  text = formatNumber(maxTotalPrice.toInt());
                  break;
                default:
                  return Container();
              }

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(text, style: style, textAlign: TextAlign.right),
              );
            },
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(days.length, (index){
            final double temp = maxTotalPrice == 0? 1 : maxTotalPrice;
            double percentage = data.values.toList()[index]['totalPrice'] / temp;
            return FlSpot(index.toDouble(),percentage*10);
          }
          ),
          isCurved: true,
          curveSmoothness: 0,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

}

String formatNumber(int number) {
  return NumberFormat.compact().format(number);
}