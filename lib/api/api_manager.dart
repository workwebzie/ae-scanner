import 'dart:io' show File, HttpHeaders;
 
 
import 'package:ae_scanner_app/api/api_config.dart';
import 'package:dio/dio.dart';
 
 
import 'package:flutter/foundation.dart';

class ApiClient {
  // 🔹 Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal() {
    _init();
  }

  late Dio _dio;
  String? _token;

  // 🔹 Base URL (Change this to your backend)
  static const String baseUrl = ApiConfig.baseUrl;

  void _init() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    ));

    // 🔹 Add interceptors for debugging and auth
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers[HttpHeaders.authorizationHeader] = "Bearer $_token";
        }
        if (kDebugMode) {
          print("➡️ [${options.method}] ${options.uri}");
          print("📦 Data: ${options.data}");
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print("✅ Response: ${response.statusCode}");
        }
        handler.next(response);
      },
      onError: (DioException e, handler) {
        if (kDebugMode) {
          print("❌ Error: ${e.response?.statusCode} - ${e.message}");
        }
        handler.next(e);
      },
    ));
  }

  // 🔹 Set or clear JWT token
  void setToken(String token) => _token = token;
  void clearToken() => _token = null;

  // 🔹 Generic GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }

  // 🔹 Generic POST request
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data,options: Options(
      headers: {
        'Content-Type': 'application/json',

      },
    ),);
  }

  // 🔹 Generic PUT request
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  // 🔹 Generic DELETE request
  Future<Response> delete(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.delete(path, queryParameters: queryParams);
  }

  // 🔹 Upload (for Excel or images)
  // Future<Response> uploadFile(String path, File file, {String fieldName = "file"}) async {
  //   final formData = FormData.fromMap({
  //     fieldName: await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
  //   });
  //   return await _dio.post(path, data: formData);
  // }



 

 

 
 

// Future<Response> uploadFile(String path, PlatformFile pickedFile, {Map<String, dynamic>? params}) async {
//   FormData formData;

//   if (kIsWeb) {
//     if (pickedFile.bytes == null) {
//       throw Exception("File bytes are null on web.");
//     }
//     formData = FormData.fromMap({
//       'file': MultipartFile.fromBytes(pickedFile.bytes!, filename: pickedFile.name),
//     });
//   } else {
//     final file = File(pickedFile.path!);
//     formData = FormData.fromMap({
//       'file': await MultipartFile.fromFile(file.path, filename: pickedFile.name),
//     });
//   }

//   // Add any additional parameters into the form fields
//   if (params != null) {
//     formData.fields.addAll(params.entries.map((entry) => MapEntry(entry.key, entry.value.toString())));
//   }

//   return await _dio.post(path, data: formData);
// }



// Future<Response> uploadFile2(String path, PlatformFile pickedFile,{Map<String, dynamic>? params  } ) async {
//   FormData formData;

//   if (kIsWeb) {
//     // On web, bytes are directly available in PlatformFile.bytes
//     if (pickedFile.bytes == null) {
//       throw Exception("File bytes are null on web.");
//     }
//     formData = FormData.fromMap({
//       'excelFile': MultipartFile.fromBytes(pickedFile.bytes!, filename: pickedFile.name),
//     });
//   } else {
//     // On mobile/desktop, convert PlatformFile to dart:io File then read bytes
//     final file = File(pickedFile.path!);
//     formData = FormData.fromMap({
//       'file': await MultipartFile.fromFile(file.path, filename: pickedFile.name),
//     });
//   }

//   return await _dio.post(path, data: formData,queryParameters: params);
// }

}
