import 'dart:convert';

import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init(){
    dio = Dio(
          BaseOptions(
            receiveDataWhenStatusError: true,
            baseUrl: 'https://www.amazon.eg/',
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: {
              'h1':'v1',
              'h2':'v2',
              'h3':'v3',
            }

          ),
    );
  }

  static Future<Response> getData({
    required String url ,
    required Map<String ,dynamic> query,
    Map<String ,dynamic>? headers,

   }) async {
    dio.options.headers = headers;
       return await  dio.get(url,queryParameters : query);
    }
  static Future<Response> postData({
    required String url ,
    required Map<String ,dynamic> data,
    Map<String ,dynamic>? query,

   }) async {
       return await  dio.post(
         url,
         queryParameters: query,
         data: data,
         
       );
    }

}