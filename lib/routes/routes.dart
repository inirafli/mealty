import 'package:go_router/go_router.dart';

import '../ui/home_screen.dart';
import '../ui/login_screen.dart';
import '../ui/register_screen.dart';
import '../ui/splash_screen.dart';

class AppRouter {
  static GoRouter configureRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
          routes: [
            GoRoute(
              path: 'register', // Accessible as '/login/register'
              builder: (context, state) => const RegisterScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
  }
}
