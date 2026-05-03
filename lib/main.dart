import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intern_app/firebase_options.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/notification_service.dart';
import 'services/supabase_service.dart';
import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'core/app_tops.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await setupLocator();
  locator<NotificationService>().init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  final supabaseService = locator<SupabaseService>();

  // Kategoriler herkese açık veri — auth gerekmez, uygulama açılışında yükle.
  await supabaseService.getCategories(forceRefresh: true);

  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('remember_me') ?? false;

  String initialRoute = Routes.loginView;

  final session = Supabase.instance.client.auth.currentSession;
  if (session != null && rememberMe) {
    final user = session.user;

    // Re-register with OneSignal so push notifications work after app restart
    locator<NotificationService>().loginUser(user.id);

    final isStudent = user.userMetadata?['is_student'] as bool?;

    if (isStudent == null || isStudent == true) {
      AppTops.studentProfile = await supabaseService.getStudentProfile();
      initialRoute = Routes.studentMainView;
    } else {
      AppTops.companyProfile = await supabaseService.getCompanyProfile();
      initialRoute = Routes.companyMainView;
    }
  }

  runApp(MainApp(initialRoute: initialRoute));
}

class MainApp extends StatelessWidget {
  final String initialRoute;
  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
      ),
      initialRoute: initialRoute,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [StackedService.routeObserver, AppTops.routeObserver],
    );
  }
}
