import 'package:simapres_skandakra/pages/violation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/achievement_page.dart';
import 'pages/absent_page.dart';
import 'pages/landing_page.dart';
import 'pages/preview_page.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Route<dynamic> buildNoTransitionRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, __, ___, child) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skanda Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return buildNoTransitionRoute(LoginPage());
          case '/landingPage':
            return buildNoTransitionRoute(const LandingPage());
          case '/previewPage':
            return buildNoTransitionRoute(const PreviewPage());
          case '/absentPage':
            return buildNoTransitionRoute(const AbsentPage());
          case '/achivementPage':
            return buildNoTransitionRoute(const AchievementPage());
          case '/violationPage':
            return buildNoTransitionRoute(const ViolationPage());
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(
                  child: Text(
                    'Halaman tidak ditemukan!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
        }
      },
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
