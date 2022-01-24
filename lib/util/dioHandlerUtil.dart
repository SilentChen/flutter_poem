import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_poem/component/alertComponent.dart';
import 'package:flutter_poem/util/constantUtil.dart';

var dio = Dio();

mineInterceptors () async {
  dio.options.baseUrl = '';
  dio.options.responseType   = ResponseType.json;
  dio.options.connectTimeout = Constant.dioConnectTimeout;
  dio.options.receiveTimeout = Constant.dioReceiveTimeout;

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options) {
        Alert.loadingmsg(position: AlertPosition.bottom, showingDuration: 0);
      },
      onResponse: (options) {
        Alert.triggerStopShowing();
      },
      onError: (error) {
        Alert.triggerStopShowing();
      }
    )
  );
}

class DioHandler {

  static setBaseUrl(String url) {
    dio.options.baseUrl = url;
  }
  
  static get (url, {queryParameters, headers = '', requests = '', successCallback = '', errorCallback = ''}) async{
    mineInterceptors();
    try{
      Response response = await dio.get(dio.options.baseUrl + url, queryParameters: queryParameters ?? {});

      if(headers != '')  { headers(response.headers); }
      if(requests != '') { requests(response.request); }

      if(response.statusCode == 200) {
        if(successCallback != '') { successCallback(response); }
        return response;
      } else {
        if(errorCallback != '') { errorCallback(response); }
        throw Exception('statusCodeError: $response');
      }
    } on DioError catch (e) {
      formatError(e);
      throw Exception('dioExcetionError: $e');
    }
  }

  static post (url, {data, success = '', error = '', headers = '', requests = '', statusCodes = '', onSendProgress}) async{
    mineInterceptors();
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
    mineInterceptors();
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
    mineInterceptors();
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