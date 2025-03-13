import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  late Dio _dio;
  final String baseUrl = dotenv.env['N8N_WEBHOOK_BASE_URL']!;
  final String webhookEndpoint = dotenv.env['N8N_WEBHOOK_PRODUCTION_ENPOINT']!;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("[API Request] ${options.method} ${options.uri}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("[API Response] ${response.statusCode} ${response.data}");
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print("[API Error] ${e.response?.statusCode} - ${e.message}");
        return handler.next(e);
      },
    ));
  }

  // Gửi tin nhắn đến webhook N8N
  Future<Response?> sendMessageToN8N(String message, String userId) async {
    try {
      final response = await _dio.post(
        webhookEndpoint,
        data: {
          "chatInput": message,
        },
      );
      return response;
    } catch (e) {
      print("Error sending message: $e");
      return null;
    }
  }
}
