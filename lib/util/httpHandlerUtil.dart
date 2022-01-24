import 'dart:convert';
import 'dart:js';

import 'package:dio/dio.dart';
import 'package:flutter_poem/component/alertComponent.dart';
import 'package:flutter_poem/util/poemConstantUtil.dart';

var dio = Dio();

poemInterceptors () async {
  dio.options.baseUrl = '';
  dio.options.connectTimeout = PoemConstant.dioConnectTimeout;
  dio.options.receiveTimeout = PoemConstant.dioReceiveTimeout;

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options) {
        Alert.loadingmsg();
      },
      onResponse: (options) {
        Alert.triggerStopShowing();
      },
      onError: (error) {

      }
    )
  );
}

class DioHandler {
  static get (url, {queryParameters, success = '', error = '', headers = '', requests = '', statusCodes = ''}) async{
    poemInterceptors();
    try{
      var response = await dio.get(dio.options.baseUrl + url, queryParameters: queryParameters ?? {});
      if(headers != '') {headers(response.headers);}
      if(requests != '') {requests(response.request);}
      if(statusCodes != '') {statusCodes(response.statusCode);}

      if(response.statusCode == 200) {
        var res = json.decode(response.data)['result'];
        if(success != '') {success(res);}
      } else {
        if(error != '') {error(response);}
        throw Exception('erroor: $response');
      }
    } on DioError catch (e) {
      formatError(e);
      throw Exception('erroor: $e');
    }
  }

  static post (url, {data, success = '', error = '', headers = '', requests = '', statusCodes = '', onSendProgress}) async{
    poemInterceptors();
    try{
      var response = await dio.post(dio.options.baseUrl + url, data: data ?? {}, onSendProgress: onSendProgress ?? () {});

      if(headers != '') {headers(response.headers);}
      if(requests != '') {requests(response.request);}
      if(statusCodes != '') {statusCodes(response.statusCode);}

      if(response.statusCode == 200) {
        var res = json.decode(response.data)['result'];
        if(success != '') {success(res);}
      } else {
        if(error != '') {error(response);}
        throw Exception('erroor: $response');
      }
    } on DioError catch (e) {
      formatError(e);
      throw Exception('erroor: $e');
    }
  }

  static download (url, saveUrl, {success, error, onReceiveProgress}) async{
    poemInterceptors();
    try{
      var response = await dio.download(dio.options.baseUrl + url, saveUrl, onReceiveProgress: onReceiveProgress ?? () {});

      if(response.statusCode == 200) {
        var res = json.decode(response.data)['result'];
        if(success != '') {success(res);}
      } else {
        if(error != '') {error(response);}
        throw Exception('erroor: $response');
      }
    } on DioError catch (e) {
      formatError(e);
      throw Exception('erroor: $e');
    }
  }

  static formData (url, data, {success, error}) async{
    poemInterceptors();
//    var formData = FormData.fromMap({
//      'name': 'wendux',
//      'age': 25,
//    });
    try{
      var response = await dio.post(dio.options.baseUrl + url, data: data ?? {});

      if(response.statusCode == 200) {
        var res = json.decode(response.data)['result'];
        if(success != '') {success(res);}
      } else {
        if(error != '') {error(response);}
        throw Exception('erroor: $response');
      }
    } on DioError catch (e) {
      formatError(e);
      throw Exception('erroor: $e');
    }
  }
}

void formatError(DioError e) {

  print("dio error: $e");

  if (e.type == DioErrorType.CONNECT_TIMEOUT) {

    print("Connection Timeout...");
  } else if (e.type == DioErrorType.SEND_TIMEOUT) {

    print("Request Overtime...");
  } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {

    print("Response Overtime...");
  } else if (e.type == DioErrorType.RESPONSE) {
    
    print("Error: 404 503");
  } else if (e.type == DioErrorType.CANCEL) {

    print("Cancle Requesting...");
  } else {

    print("Undefined Error...");
  }
}