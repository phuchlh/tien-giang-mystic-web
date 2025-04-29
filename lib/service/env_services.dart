class Env {
  static const String aiURL =
      String.fromEnvironment('SUPABASE_URL_TIEN_GIANG_MYSTIC_AI');
  static const String aiKey =
      String.fromEnvironment('ANON_KEY_TIEN_GIANG_MYSTIC');

  static const String businessURL =
      String.fromEnvironment('SUPABASE_URL_TIEN_GIANG_MYSTIC_BUSINESS');
  static const String businessKey =
      String.fromEnvironment('ANON_KEY_TIEN_GIANG_MYSTIC_BUSINESS');
  static const String openAIAPIKey = String.fromEnvironment('OPEN_AI_API_KEY');

  static const String n8nBase = String.fromEnvironment('N8N_WEBHOOK_BASE_URL');
  static const String n8nTest =
      String.fromEnvironment('N8N_WEBHOOK_TEST_ENPOINT');
  static const String n8nProd =
      String.fromEnvironment('N8N_WEBHOOK_PRODUCTION_ENPOINT');
  static const String serper = String.fromEnvironment('SERPER_BASE_URL');
  static const String apiKey = String.fromEnvironment('API_KEY');

  static const String webhookTest =
      String.fromEnvironment('N8N_WEBHOOK_TEST_ENPOINT');
  static const String webhookProd =
      String.fromEnvironment('N8N_WEBHOOK_PRODUCTION_ENPOINT');
  static const String endPoint = String.fromEnvironment('N8N_WEBHOOK_BASE_URL');
  static const baseURL = String.fromEnvironment('N8N_WEBHOOK_BASE_URL');

  static const String serperKey = String.fromEnvironment('SERPER_KEY');
}
