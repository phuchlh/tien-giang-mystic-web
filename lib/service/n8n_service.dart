import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tien_giang_mystic/utils/enum.dart';
import '../service/env_services.dart';

class N8NService {
  static final String baseURL = Env.n8nBase;
  static final String webhookTest = Env.webhookTest;
  static final String webhookProd = Env.webhookProd;
  static final String endPoint = Env.endPoint;

  static final _dio = Dio(
    BaseOptions(
      baseUrl: baseURL,
      receiveDataWhenStatusError: false,
      connectTimeout: const Duration(seconds: 300),
      receiveTimeout: const Duration(seconds: 300),
    ),
  )..interceptors.addAll([
      PrettyDioLogger(
        request: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: false,
        requestBody: true,
      ),
    ]);

  static postWithToken(EN8NWebhookType type, body, token) async {
    final typeUrl = type == EN8NWebhookType.TEST ? webhookTest : webhookProd;
    return await _dio.post(
      endPoint + typeUrl,
      data: body,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-type": "application/json",
          "withCredentials": true,
        },
      ),
    );
  }

  Future<Response> postMessage(String message, EN8NWebhookType type) async {
    try {
      final webhook = type == EN8NWebhookType.TEST ? webhookTest : webhookProd;
      final response = await _dio.post(
        webhook,
        data: {
          'chatInput': message,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch chi tiết của một mục theo ID
  Future<Response> fetchDetails(String id) async {
    try {
      final response = await _dio.get(
        '/details/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
