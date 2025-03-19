import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../models/news_model.dart';

class SerperService {
  final String apiKey = dotenv.env['SERPER_KEY']!;

  final Dio _dio;

  SerperService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://google.serper.dev',
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

  /// Gọi API Serper News với query `q`
  Future<List<News>> fetchSearch(String query) async {
    try {
      final response = await _dio.get(
        '/news',
        queryParameters: {
          'q': query,
          'location': 'Tien+Giang%2C+Vietnam',
          'gl': 'vn',
          'hl': 'vi',
          'num': 10,
          'apiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final searchModel = NewsModel.fromJson(response.data);
        final organics = searchModel.news!;
        return organics;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> fetchReviews(String query) async {
    try {
      final response = await _dio.get(
        '/images',
        queryParameters: {
          'q': query,
          'location': 'Tien+Giang%2C+Vietnam',
          'gl': 'vn',
          'hl': 'vi',
          'apiKey': apiKey,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
