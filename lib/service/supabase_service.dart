import 'package:supabase_flutter/supabase_flutter.dart';

import '../service/env_services.dart';

class SupabaseService {
  // Singleton pattern
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;

  SupabaseService._internal();

  late final SupabaseClient tgMysticAI;
  late final SupabaseClient tgMysticBusiness;

  final String businessURL = Env.businessURL;
  final String businessKey = Env.businessKey;
  final String aiURL = Env.aiURL;
  final String aiKey = Env.aiKey;

  Future<void> init() async {
    print("businessURL: $businessURL");
    print("aiURL: $aiURL");
    try {
      // Initialize only once — this is the auth/session client
      await Supabase.initialize(
        url: businessURL,
        anonKey: businessKey,
        debug: true,
      );

      // Set business client to the initialized one (handles login, session, etc.)
      tgMysticBusiness = Supabase.instance.client;

      // Create a secondary client for AI database (used for querying only, no auth)
      tgMysticAI = SupabaseClient(aiURL, aiKey);

      print('[SupabaseService] ✅ Clients initialized successfully');
    } catch (e, stackTrace) {
      print(
          '[SupabaseService] ❌ Failed to initialize Supabase: $e\n$stackTrace');
      rethrow;
    }
  }

  // Helpers for other parts of the app
  SupabaseClient getBusinessClient() => tgMysticBusiness;
  SupabaseClient getAIClient() => tgMysticAI;

  Session? get currentSession => tgMysticBusiness.auth.currentSession;

  String? get accessToken => currentSession?.accessToken;
}
