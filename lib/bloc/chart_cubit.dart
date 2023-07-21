import 'package:chart_example/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {

  final Repository repository;

  ChartCubit({required this.repository}) : super(ChartInitial());

  Future<void> getDataStatistical()async{
    try{
      emit(ChartLoading());
      final data = await repository.getStatistical7days();
      if(data.$1==null){
        emit(ChartLoaded(data: data.$2!));
      } else{
        emit(ChartError());
      }
    }catch(e){
      print(e.toString());
    }
  }
}
