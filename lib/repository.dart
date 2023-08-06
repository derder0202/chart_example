
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ExceptionServer implements Exception{
  final int statusCode;
  final String message;

  ExceptionServer(this.statusCode,this.message);
}


class Repository{
  final dio = Dio();
  Future<Either<ExceptionServer, Map<String,dynamic>?>> getStatistical7days()async{
    try{
      final res = await dio.get("http://192.168.0.106:3000/api/shops/64c7b6f9b79dfa0786135678/statistical");
      if(res.statusCode == 200){
        final data = res.data as Map<String,dynamic>;
        return Right(data);
      } else{
        return Left(ExceptionServer(res.statusCode!, res.data.toString()));
      }
    } catch (e){
      print(e);
      return Left(ExceptionServer(0, "server error"));
    }
  }

  Future<Either<ExceptionServer, Map<String,dynamic>?>> getDataStatisticalByTime(DateTime startDay, DateTime endDay)async{
    try{
      // final startDay = DateTime(2023,7,20);
      // final endDay = DateTime(2023,7,22);
      // print(DateFormat.yMMMMd().format(startDay));
      // final c = DateFormat.yMMMMd().format(startDate);
      final res = await dio.post("http://192.168.0.106:3000/api/shops/64ace8982b17ca776de7ce17/getShopStatisticalByTime",data: {
        'startDay':DateFormat.yMMMMd().format(startDay),
        'endDay':DateFormat.yMMMMd().format(endDay)
      });
      print(res.data);
      if(res.statusCode == 200){
        final data = res.data;

        return Right(data);
      } else{
        return Left(ExceptionServer(res.statusCode!, res.data.toString()));
      }
    } catch (e){
      print(e);
      return Left(ExceptionServer(0, "server error"));
    }
  }


}