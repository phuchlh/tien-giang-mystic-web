// ignore_for_file: constant_identifier_names

enum SlidingStatus { hide, showDetail, showCommon }

enum DataLoadingStatus { pending, loading, loaded, error }

enum GetImageStatus { pending, loading, loaded, error }

enum ApiMethod { GET, POST, PUT, DELETE }

enum EBaseURLType { N8N_TEST, N8N_PROD, SUPABASE, SERPER_NEWS, SERPER_PLACES }

enum EN8NWebhookType { TEST, PROD }

enum EPlaceGeneratedStatus { HOLD, GENERATED, FILTERED }

enum EButtonClickType { NEXT, BACK }

enum EPlayType { INIT, GENERATING, PLAY, PAUSE, STOP }

enum EDrawerTypeButton { HOLD, PLACE, TOUR, LOGOUT }

enum EStatusTourBookmark { HOLD, LOADING, SUCCESS, ERROR, EMPTY }

enum EStatusPlaceBookmark { HOLD, LOADING, SUCCESS, ERROR, EMPTY }

enum ECommonStatus { HOLD, LOADING, SUCCESS, ERROR, EMPTY }
