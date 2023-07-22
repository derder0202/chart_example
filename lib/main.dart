import 'package:chart_example/bar_char_count.dart';
import 'package:chart_example/bloc/chart_cubit.dart';
import 'package:chart_example/bloc/count_statistical_cubit.dart';
import 'package:chart_example/linechart.dart';
import 'package:chart_example/repository.dart';
import 'package:chart_example/resource/app_colors.dart';
import 'package:chart_example/resource/color_extentions.dart';
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
      home: Scaffold(body: Container(
          color: AppColors.pageBackground,
          child: const Column(
            children: [
              ChartHolder(),
              CountStatisticalWidget()
            ],
          )
      )),

    );
  }
}

class CountStatisticalWidget extends StatefulWidget {
  const CountStatisticalWidget({super.key});
  @override
  State<CountStatisticalWidget> createState() => _CountStatisticalWidgetState();
}
class _CountStatisticalWidgetState extends State<CountStatisticalWidget> {
  final style = TextStyle(
    color: AppColors.contentColorBlue.darken(20),
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      CountStatisticalCubit(repository: Repository())
        ..getDataStatisticalByTime(DateTime(2023,7,20),DateTime(2023,7,22)),
      child: BlocBuilder<CountStatisticalCubit, CountStatisticalState>(
        builder: (context, state) {
          if(state is CountStatisticalLoading) return const Center(child: CircularProgressIndicator());
          if(state is CountStatisticalLoaded){
            return Column(
              children: [
                Text("check trong kia tu truyen vao nhe",style: style,),
                Text("Count: ${state.count.toString()}",style: style,),
                Text("total price: ${state.totalPrice.toString()}",style: style,)
              ],
            );
          }
          return const Text("error");

        },
      ),
    );
  }
}


class ChartHolder extends StatefulWidget {
  const ChartHolder({super.key});

  @override
  State<ChartHolder> createState() => _ChartHolderState();
}

class _ChartHolderState extends State<ChartHolder> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ChartCubit(repository: Repository())
        ..getDataPast7Days(),
      child: Column(
        children: [
          SafeArea(child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: BlocBuilder<ChartCubit, ChartState>(
              builder: (context, state) {
                if (state is ChartLoading)
                  return const Center(child: CircularProgressIndicator());
                if (state is ChartLoaded) {
                  return Column(
                    children: [
                      LineChartRevenue(data: state.data,),
                      const SizedBox(height: 20,),
                      AspectRatio(
                        aspectRatio: 1.6,
                        child: BarChartCount(data: state.data,),
                      ),
                    ],
                  );
                }
                return const Text("error");
              },
            ),
          )),
        ],
      ),
    );
  }
}

