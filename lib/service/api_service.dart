import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../utils/enum.dart';
import '../service/env_services.dart';

class ApiService {
  final Dio _dio;

  // final String n8nBase = dotenv.env['N8N_WEBHOOK_BASE_URL']!;
  // final String n8nTest = dotenv.env['N8N_WEBHOOK_TEST_ENPOINT']!;
  // final String n8nProd = dotenv.env['N8N_WEBHOOK_PRODUCTION_ENPOINT']!;
  // final String serper = dotenv.env['SERPER_BASE_URL']!;
  // final String apiKey = dotenv.env['API_KEY']!;

  static final String n8nBase = Env.n8nBase;
  static final String n8nTest = Env.n8nTest;
  static final String n8nProd = Env.n8nProd;
  static final String serper = Env.serper;
  static final String apiKey = Env.apiKey;

  ApiService({String? baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? '',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    _dio.interceptors.add(
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
  }

  void setHeaders(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// Lấy Base URL tùy theo loại API
  String _getBaseURL(EBaseURLType type) {
    switch (type) {
      case EBaseURLType.N8N_TEST:
        return '$n8nBase$n8nTest';
      case EBaseURLType.N8N_PROD:
        return '$n8nBase$n8nProd';
      case EBaseURLType.SUPABASE:
        return ""; // Cập nhật nếu cần
      case EBaseURLType.SERPER_NEWS:
        return '$serper/news';
      case EBaseURLType.SERPER_PLACES:
        return '$serper/places';
    }
  }
}
