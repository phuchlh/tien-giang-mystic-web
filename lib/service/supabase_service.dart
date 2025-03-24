import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  late final SupabaseClient tgMysticAI;
  late final SupabaseClient tgMysticBusiness;

  final aiURL = dotenv.env['SUPABASE_URL_TIEN_GIANG_MYSTIC']!;
  final aiKey = dotenv.env['ANON_KEY_TIEN_GIANG_MYSTIC']!;

  final businessURL = dotenv.env['SUPABASE_URL_TIEN_GIANG_MYSTIC_BUSINESS']!;
  final businessKey = dotenv.env['ANON_KEY_TIEN_GIANG_MYSTIC_BUSINESS']!;

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  Future<void> init() async {
    tgMysticAI = SupabaseClient(aiURL, aiKey);
    tgMysticBusiness = SupabaseClient(businessURL, businessKey);

    print('SupabaseService initialized with two clients');
  }

  SupabaseClient getAIClient() => tgMysticAI;
  SupabaseClient getBusinessClient() => tgMysticBusiness;
}
