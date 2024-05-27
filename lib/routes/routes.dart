import 'package:go_router/go_router.dart';
import 'package:mealty/ui/main_screen.dart';

import '../ui/home_screen.dart';
import '../ui/login_screen.dart';
import '../ui/register_screen.dart';
import '../ui/splash_screen.dart';
import '../utils/custom_page_transitions.dart';

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
          pageBuilder: (context, state) {
            return createSlideFromLeftTransitionPage(
              page: const LoginScreen(),
            );
          },
          routes: [
            GoRoute(
              path: 'register',
              pageBuilder: (context, state) {
                return createSlideFromRightTransitionPage(
                  page: const RegisterScreen(),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => const MainScreen(),
        ),
      ],
    );
  }
}
