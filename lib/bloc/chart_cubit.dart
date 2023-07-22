import 'package:chart_example/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {

  final Repository repository;

  ChartCubit({required this.repository}) : super(ChartInitial());

  Future<void> getDataPast7Days()async{
    try{
      emit(ChartLoading());
      final data = await repository.getStatistical7days();
      data.fold(
              (l) =>  emit(ChartError()),
              (r) => emit(ChartLoaded(data: r!))
      );
    }catch(e){
      print(e.toString());
    }
  }




}
