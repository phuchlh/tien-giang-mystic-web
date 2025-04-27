import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main_binding.dart';
import 'modules/map_screen/map_screen_page.dart';
import 'route/app_page.dart';
import 'service/session_service.dart';
import 'service/supabase_service.dart';
import 'themes/theme.dart';
import 'utils/app_logger.dart';

Future<void> main() async {
  // Ensure proper initialization of Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Add error handling for Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    AppLogger.error('Flutter error: ${details.exception}');
  };

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Initialize Supabase
    final supabaseService = SupabaseService();
    await supabaseService.init();
    AppLogger.debug("Supabase initialized successfully");

    runApp(const MyApp());
  } catch (e, stackTrace) {
    AppLogger.error('Initialization error: $e\n$stackTrace');
    // Show error screen instead of crashing
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error initializing app: $e'),
        ),
      ),
    ));
  }
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
      navigatorKey: Get.key,
      home: Builder(
        builder: (context) {
          return MapScreenPage();
        },
      ),
    );
  }
}
