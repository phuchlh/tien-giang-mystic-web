import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main_binding.dart';
import 'modules/map_screen/map_screen_page.dart';
import 'route/app_page.dart';
import 'themes/theme.dart';
import 'utils/responsive.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  final String urlSupabase = dotenv.env['SUPABASE_URL_TIEN_GIANG_MYSTIC']!;
  final String anonKey = dotenv.env['ANON_KEY_TIEN_GIANG_MYSTIC']!;

  await Supabase.initialize(
    url: urlSupabase,
    anonKey: anonKey,
  );
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
