part of 'count_statistical_cubit.dart';

abstract class CountStatisticalState extends Equatable{}


class CountStatisticalInitial extends CountStatisticalState {
  @override
  List<Object?> get props => [];
}

class CountStatisticalLoading extends CountStatisticalState {
  @override
  List<Object?> get props => [];
}

class CountStatisticalLoaded extends CountStatisticalState {
  final int count;
  final int totalPrice;

  CountStatisticalLoaded({required this.count, required this.totalPrice});

  @override
  List<Object?> get props => [];
}

class CountStatisticalError extends CountStatisticalState {
  @override
  List<Object?> get props => [];
}
