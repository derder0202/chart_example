
import 'package:dio/dio.dart';

class ExceptionServer implements Exception{
  final int statusCode;
  final String message;

  ExceptionServer(this.statusCode,this.message);
}

class Repository{
  final dio = Dio();
  Future<(ExceptionServer?,List<dynamic>?)> getStatistical7days()async{
    final res = await dio.get("http://192.168.0.106:3000/api/shops/64ace8982b17ca776de7ce17/statistical");
    if(res.statusCode == 200){
      final data = res.data as List;
      return (null,data);
    } else{
      return (ExceptionServer(res.statusCode!,"server error"),null);
    }
  }
}