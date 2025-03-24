import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tien_giang_mystic/service/session_service.dart';
import 'package:tien_giang_mystic/service/supabase_service.dart';

import 'main_binding.dart';
import 'modules/map_screen/map_screen_page.dart';
import 'route/app_page.dart';
import 'themes/theme.dart';
import 'utils/responsive.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  // final supabaseService = SupabaseService();
  // await supabaseService.init();

  // Khởi tạo SupabaseService
  // Khởi tạo SupabaseService
  final supabaseService = SupabaseService();
  try {
    await supabaseService.init();
    print('SupabaseService initialized successfully');
  } catch (e) {
    print('Error initializing SupabaseService: $e');
    // Có thể hiển thị màn hình lỗi hoặc thoát ứng dụng nếu cần
    return;
  }
  String sessionId = await SessionService.getOrCreateSessionId();
  print("Session ID: $sessionId");

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
