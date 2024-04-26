import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealty/common/styles.dart';
import 'package:mealty/ui/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Mealty',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: surfaceColor,
          onBackground: onBackgroundColor,
          onPrimary: onPrimaryColor
        ),
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0.8,
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: onPrimaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        textTheme: appTextTheme,
      ),
      home: const LoginScreen(),
    );
  }
}