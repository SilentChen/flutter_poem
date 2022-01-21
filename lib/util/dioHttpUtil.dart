import 'dart:convert';
import 'package:dio/dio.dart';

var dio = Dio();

interceptors () async{
//  dio.options.contentType = 'application/json;charset=UTF-8';
//  dio.options.headers = {'testHeader':'aaaa'};

//  var tokens = await Storage.getString('token');
  dio.options.baseUrl = '';
  dio.options.connectTimeout = 15000;
  dio.options.receiveTimeout = 15000;
  dio.interceptors.add(
    InterceptorsWrapper(
        onRequest: (options) async {
//          print("method = ${options.method.toString()}");
//          print("url = ${options.uri.toString()}");
//          print("headers = ${options.headers}");
//          print("params = ${options.queryParameters}");
//          此处可网络请求之前做相关配置，比如会所有请求添加token
//          options.queryParameters['token'] = 'testtoken123443423';
//          options.headers["token"] = "testtoken123443423";
//          if (tokens == null) {
//            dio.lock();
//            return dio.get('/token').then((e) {
//
//              options.queryParameters['token'] = e.data['data']['token'];
//              Storage.setString('token', {token: e.data['data']['token']});
//
//              return options;
//            }).whenComplete(() => dio.unlock());
//          } else {
//            options.queryParameters['token'] = 'testtoken123443423';
//            return options;
//          }

          return options;
        },
        onResponse: (response) {
          //此处拦截工作在数据返回之后，可在此对dio请求的数据做二次封装或者转实体类等相关操作
          return response;
        },
        onError: (error) {
          //处理错误请求
          return error;
        }),
  );

}
class DioHttp {

  static const downloadUrl = 'https://dev1.mifengff.com/obhcx4';

//  DioHttp.get(
//  'http://www.phonegap100.com/appapi.php?a=getPortalList',
//  queryParameters: {
//  'catid': 20, 'page': page
//  },
//  success: (e) {
//  setState(() {list.addAll(e);page++;});
//  if(e.length < 20) {setState(() {pageFlag = false;});}
//  });

  static get (url, {queryParameters, success = '', error = '', headers = '', requests = '', statusCodes = ''}) async{
    interceptors();
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
    interceptors();
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
    interceptors();
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
    interceptors();
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