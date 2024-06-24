import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:mealty/ui/add_food_screen.dart';
import 'package:mealty/ui/location_picker_screen.dart';
import 'package:mealty/ui/main_screen.dart';
import 'package:mealty/ui/order_screen.dart';
import 'package:provider/provider.dart';

import '../data/model/food_post.dart';
import '../data/model/user.dart';
import '../provider/food_provider.dart';
import '../ui/food_detail_screen.dart';
import '../ui/login_screen.dart';
import '../ui/profile_screen.dart';
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
          builder: (context, state) => const ProfileScreen(),
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
              path: 'addFood',
              pageBuilder: (context, state) {
                return createSlideFromBottomTransitionPage(
                  page: const AddFoodScreen(),
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
