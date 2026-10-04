import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helpers/app_colors.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'services/mock_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize JSON mock data service
  await MockDataService().initialize();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const EcormmerceApp(),
    ),
  );
}

class EcormmerceApp extends StatelessWidget {
  const EcormmerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MA Studio E-Commerce',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.black,
        colorScheme: const ColorScheme.light(
          primary: AppColors.black,
          secondary: AppColors.darkGrey,
          surface: AppColors.white,
          error: AppColors.alertRed,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.black),
          titleTextStyle: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: const OnboardingScreen(),
    );
  }
}
