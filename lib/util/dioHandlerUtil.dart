import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_poem/component/alertComponent.dart';
import 'package:flutter_poem/util/constantUtil.dart';

var dio = Dio();

mineInterceptors({onRequestCallback = '', onResponseCallback = '', onErrorCallback = ''}) async {
  dio.options.baseUrl = '';
  dio.options.responseType   = ResponseType.json;
  dio.options.connectTimeout = Constant.dioConnectTimeout;
  dio.options.receiveTimeout = Constant.dioReceiveTimeout;

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions requestOptions) {
        Alert.loadingmsg(position: AlertPosition.bottom, showingDuration: 0);
        if(onRequestCallback != '') onRequestCallback(requestOptions);
      },
      onResponse: (Response response) {
        Alert.triggerStopShowing();
        if(onResponseCallback != '') onResponseCallback(response);
      },
      onError: (error) {
        Alert.triggerStopShowing();
        if(onErrorCallback != '') onErrorCallback(error);
      }
    )
  );
}

class DioHandler {

  static setBaseUrl(String url) {
    dio.options.baseUrl = url;
  }
  
  static get (url, {queryParameters, headers = '', requests = '', onRequestCallback = '', onResponseCallback = '', onErrorCallback = ''}) async{
    mineInterceptors();
    try{
      Response response = await dio.get(dio.options.baseUrl + url, queryParameters: queryParameters ?? {});

      if(headers != '')  { headers(response.headers); }
      if(requests != '') { requests(response.request); }

      if(response.statusCode == 200) {
        if(onResponseCallback != '') { onResponseCallback(response); }
        return response;
      } else {
        if(onErrorCallback != '') { onErrorCallback(response); }
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