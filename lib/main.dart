import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mealty/common/styles.dart';
import 'package:mealty/ui/home_screen.dart';
import 'package:mealty/ui/login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:mealty/ui/register_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final GoRouter router = GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) =>
                authProvider.authState == AuthState.authorized
                    ? const HomeScreen()
                    : const LoginScreen(),
              ),
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginScreen(),
              ),
              GoRoute(
                path: '/register',
                builder: (context, state) => const RegisterScreen(),
              ),
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
            redirect: (context, state) {
              final isAuthenticated = authProvider.authState ==
                  AuthState.authorized;
              final isLoggingIn = state.location == '/login' ||
                  state.location == '/register';

              if (!isAuthenticated && !isLoggingIn) return '/login';
              if (isAuthenticated && (state.location == '/login' ||
                  state.location == '/register')) {
                return '/home';
              }
              return null;
            },
          );

          return MaterialApp.router(
            routerConfig: router,
            title: 'Mealty',
            theme: ThemeData(
              colorScheme: Theme
                  .of(context)
                  .colorScheme
                  .copyWith(
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
          );
        },
      ),
    );
  }
}