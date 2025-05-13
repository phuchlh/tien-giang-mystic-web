enum SlidingStatus {
  hide,
  showDetail,
  showCommon,
}

enum DataLoadingStatus {
  pending,
  loading,
  loaded,
  error,
}

enum GetImageStatus {
  pending,
  loading,
  loaded,
  error,
}

enum ApiMethod {
  GET,
  POST,
  PUT,
  DELETE,
}

enum EBaseURLType {
  N8N_TEST,
  N8N_PROD,
  SUPABASE,
  SERPER_NEWS,
  SERPER_PLACES,
}

enum EN8NWebhookType {
  TEST,
  PROD,
}

enum EPlaceGenerated {
  HOLD,
  GENERATED,
}

enum EButtonClickType {
  NEXT,
  BACK,
}

enum EPlayType { INIT, GENERATING, PLAY, PAUSE, STOP }

enum EDrawerTypeButton { HOLD, PLACE, TOUR, LOGOUT }
