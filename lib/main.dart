import 'package:chart_example/bloc/chart_cubit.dart';
import 'package:chart_example/repository.dart';
import 'package:chart_example/resource/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) =>
        ChartCubit(repository: Repository())
          ..getDataStatistical(),
        child: const Scaffold(body: SafeArea(child: Padding(
          padding: EdgeInsets.all(10.0),
          child: MyHomePage(title: "chart"),
        ))),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        if(state is ChartLoading) return const CircularProgressIndicator();
        if(state is ChartLoaded){
          return Stack(
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
                    showAvg ? avgData() : mainData(state.data),
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                height: 34,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showAvg = !showAvg;
                    });
                  },
                  child: Text(
                    'avg',
                    style: TextStyle(
                      fontSize: 12,
                      color: showAvg ? Colors.white.withOpacity(0.5) : Colors
                          .white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return const Text("error");
      },
    );
  }

  List<String> getPastDays(int numberOfDays) {
    List<String> pastDays = [];
    DateTime today = DateTime.now();
    for (int i = 0; i < numberOfDays; i++) {
      DateTime pastDay = today.subtract(Duration(days: i + 1));
      String formattedDate = DateFormat('dd/MM').format(pastDay);
      pastDays.add(formattedDate);
    }
    return pastDays;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    final days = getPastDays(7);
    Widget text;

    if (value.toInt() >= 7) {
      text = const Text('', style: style);
    } else {
      text = Text(days[value.toInt()], style: style);
    }
    // switch (value.toInt()) {
    //   case 0:
    //     text = ;
    //     break;
    //   case 3:
    //     text = const Text('JUN', style: style);
    //     break;
    //   case 5:
    //     text = const Text('SEP', style: style);
    //     break;
    //
    //   default:
    //     text = const Text('', style: style);
    //     break;
    // }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }


  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '0M';
        break;
      case 5:
        text = '30k';
        break;
      case 10:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(List<dynamic> data) {
    double maxTotalPrice = data.map<double>((item) => double.parse(item['totalPrice'].toString())).reduce((a, b) => a > b ? a : b);
    final days = getPastDays(7);
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
              const style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              Widget text;
              if (value.toInt() >= 7) {
                text = const Text('', style: style);
              } else {
                text = Text(days[value.toInt()], style: style);
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
              const style = TextStyle(
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

              return Text(text, style: style, textAlign: TextAlign.right);
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
            if(index<data.length){
              double percentage = data[index]['totalPrice'] / maxTotalPrice;
              if(data[index]["_id"] == days[index]){
                return FlSpot(index.toDouble(),percentage*10);
              }
              return FlSpot(index.toDouble(),0);
            } else{
              return FlSpot(index.toDouble(),0);
            }
          }
          ),
          // const [
          //   FlSpot(0, 3),
          //   FlSpot(1, 2),
          //   FlSpot(2, 5),
          //   FlSpot(3, 3.1),
          //   FlSpot(4, 4),
          //   FlSpot(5, 3),
          //   FlSpot(6, 4),
          // ],
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
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              final days = getPastDays(7);
              Widget text;

              if (value.toInt() >= 7) {
                text = const Text('', style: style);
              } else {
                text = Text(days[value.toInt()], style: style);
              }
              // switch (value.toInt()) {
              //   case 0:
              //     text = ;
              //     break;
              //   case 3:
              //     text = const Text('JUN', style: style);
              //     break;
              //   case 5:
              //     text = const Text('SEP', style: style);
              //     break;
              //
              //   default:
              //     text = const Text('', style: style);
              //     break;
              // }

              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: text,
              );
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
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