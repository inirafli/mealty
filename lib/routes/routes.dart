import 'package:go_router/go_router.dart';
import 'package:mealty/ui/manage_food_screen.dart';
import 'package:mealty/ui/hometab/notifications_screen.dart';
import 'package:mealty/ui/location_picker_screen.dart';
import 'package:mealty/ui/main_screen.dart';
import 'package:mealty/ui/profiletab/profile_food_list_screen.dart';

import '../ui/food_detail_screen.dart';
import '../ui/login_screen.dart';
import '../ui/profiletab/profile_edit_screen.dart';
import '../ui/register_screen.dart';
import '../ui/splash_screen.dart';
import '../utils/custom_page_transitions.dart';
import '../utils/image_view_screen.dart';

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
              key: state.pageKey,
            );
          },
          routes: [
            GoRoute(
              path: 'register',
              pageBuilder: (context, state) {
                return createSlideFromRightTransitionPage(
                  page: const RegisterScreen(),
                  key: state.pageKey,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/main',
          pageBuilder: (context, state) {
            return createSlideFromTopTransitionPage(
              page: const MainScreen(),
              key: state.pageKey,
            );
          },
          routes: [
            GoRoute(
              path: 'manageFood',
              pageBuilder: (context, state) {
                final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
                final bool isEdit = extra?['isEdit'] ?? false;
                final Map<String, dynamic>? foodData = extra?['foodData'];

                return createSlideFromBottomTransitionPage(
                  page: ManageFoodScreen(isEdit: isEdit, foodData: foodData),
                  key: state.pageKey,
                );
              },
              routes: [
                GoRoute(
                  path: 'locationPicker',
                  pageBuilder: (context, state) {
                    return createSlideFromBottomTransitionPage(
                      page: const LocationPickerScreen(),
                      key: state.pageKey,
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'foodDetail',
              pageBuilder: (context, state) {
                final String postId = state.extra as String;
                return createSlideFromBottomTransitionPage(
                  page: FoodDetailScreen(postId: postId),
                  key: state.pageKey,
                );
              },
            ),
            GoRoute(
              path: 'profileFoodList',
              pageBuilder: (context, state) {
                return createSlideFromBottomTransitionPage(
                  page: const ProfileFoodScreen(),
                  key: state.pageKey,
                );
              },
            ),
            GoRoute(
              path: 'profileEdit',
              pageBuilder: (context, state) {
                return createSlideFromBottomTransitionPage(
                  page: const ProfileEditScreen(),
                  key: state.pageKey,
                );
              },
            ),
            GoRoute(
              path: 'notifications',
              pageBuilder: (context, state) {
                return createSlideFromBottomTransitionPage(
                  page: const NotificationScreen(),
                  key: state.pageKey,
                );
              },
            ),
            GoRoute(
              path: 'imageFullScreen',
              pageBuilder: (context, state) {
                final String imageUrl = state.extra as String;
                return createSlideFromBottomTransitionPage(
                  page: ImageFullScreenView(imageUrl: imageUrl),
                  key: state.pageKey,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
