import 'package:chart_example/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'count_statistical_state.dart';

class CountStatisticalCubit extends Cubit<CountStatisticalState> {
  CountStatisticalCubit({required this.repository}) : super(CountStatisticalInitial());
  final Repository repository;

  Future<void> getDataStatisticalByTime(DateTime startDay, DateTime endDay)async{
    try{
      emit(CountStatisticalLoading());
      final data = await repository.getDataStatisticalByTime(startDay,endDay);
      data.fold(
              (l) =>  emit(CountStatisticalError()),
              (r) => emit(CountStatisticalLoaded(count: r!['count'],totalPrice: r!['totalPrice']))
      );

    }catch(e){
      print(e.toString());
    }
  }
}
