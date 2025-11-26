import 'package:dio/dio.dart';

import 'api_exceptions.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  late Dio dio;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://mock.tokyocarclub.com/api",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    // Interceptors
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<Response> get(String url, {Map<String, dynamic>? query}) async {
    try {
      return await dio.get(url, queryParameters: query);
    } catch (e) {
      throw handleApiError(e);
    }
  }

  Future<Response> post(String url, {Map<String, dynamic>? body}) async {
    try {
      return await dio.post(url, data: body);
    } catch (e) {
      throw handleApiError(e);
    }
  }
}
