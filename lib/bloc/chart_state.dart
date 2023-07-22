part of 'chart_cubit.dart';

abstract class ChartState extends Equatable{}

class ChartInitial extends ChartState {
  @override
  List<Object?> get props => [];
}

class ChartLoaded extends ChartState {
  final Map<String,dynamic> data;

  ChartLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class ChartLoading extends ChartState {
  @override
  List<Object?> get props => [];
}

class ChartError extends ChartState {
  @override
  List<Object?> get props => [];
}