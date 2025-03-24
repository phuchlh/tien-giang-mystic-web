import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tien_giang_mystic/utils/enum.dart';

class N8NService {
  static final String webhookTest = dotenv.env['N8N_WEBHOOK_TEST_ENPOINT']!;
  static final String webhookProd =
      dotenv.env['N8N_WEBHOOK_PRODUCTION_ENPOINT']!;
  static final String endPoint = dotenv.env['N8N_WEBHOOK_BASE_URL']!;

  static final _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['N8N_WEBHOOK_BASE_URL'] ?? '',
      receiveDataWhenStatusError: false,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  )..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

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
