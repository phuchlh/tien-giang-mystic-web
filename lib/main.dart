import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'main_binding.dart';
import 'modules/map_screen/map_screen_page.dart';
import 'route/app_page.dart';
import 'service/session_service.dart';
import 'service/supabase_service.dart';
import 'themes/theme.dart';
import 'utils/app_logger.dart';
import 'utils/responsive.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final supabaseService = SupabaseService();
  try {
    await supabaseService.init();
    // check if dotenv is loaded
    if (dotenv.env['FIREBASE_API_KEY'] != null) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: dotenv.env['FIREBASE_API_KEY']!,
          authDomain: "${dotenv.env['FIREBASE_PROJECT_ID']!}.firebaseapp.com",
          projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
          storageBucket:
              "${dotenv.env['FIREBASE_PROJECT_ID']!}.firebasestorage.app",
          messagingSenderId: dotenv.env['FIREBASE_SENDER_ID']!,
          appId: dotenv.env['FIREBASE_APP_ID']!,
          measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID']!,
        ),
      );
    }
    AppLogger.debug("Initialize Successfully");
  } catch (e) {
    AppLogger.error(e);
    // Có thể hiển thị màn hình lỗi hoặc thoát ứng dụng nếu cần
    return;
  }
  String sessionId = await SessionService.getOrCreateSessionId();
  AppLogger.info("Your sessionID is $sessionId");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tien Giang Mystic',
      getPages: AppPages.pages,
      theme: MaterialTheme(TextTheme()).light(),
      initialBinding: MainBinding(),
      home: Builder(
        builder: (context) {
          Get.put(Responsive(context), permanent: true);
          return MapScreenPage();
        },
      ),
    );
  }
}
