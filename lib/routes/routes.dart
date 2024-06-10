import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:mealty/ui/add_food_screen.dart';
import 'package:mealty/ui/location_picker_screen.dart';
import 'package:mealty/ui/main_screen.dart';

import '../data/model/food_post.dart';
import '../data/model/user.dart';
import '../ui/food_detail_screen.dart';
import '../ui/login_screen.dart';
import '../ui/register_screen.dart';
import '../ui/splash_screen.dart';
import '../utils/custom_page_transitions.dart';
import '../utils/image_view_screen.dart';

class AppRouter {
  static GoRouter configureRouter() {
    // Dummy FoodPost data
    // final dummyPost = FoodPost(
    //   id: 'posts-1717648063749',
    //   category: 'snacks',
    //   description:
    //       'Kentang goreng lezat buatan rumahan asli tanpa penyedap dan langsung dari kentang di kebun.',
    //   image:
    //       'https://firebasestorage.googleapis.com/v0/b/mealty-408b8.appspot.com/o/foods%2Ffoods-1717648062566?alt=media&token=0e28a9fb-bb0b-4ba7-b299-a9289a84a7d1',
    //   location: const GeoPoint(-6.401476593216709, 106.83764453977346),
    //   // Dummy location
    //   name: 'Kentang Goreng Rumahan',
    //   price: 20000,
    //   publishedDate: Timestamp(1717648063, 751663000),
    //   saleTime: Timestamp.fromDate(DateTime(2024, 6, 11, 09, 00, 00)),
    //   sellingType: 'commercial',
    //   userId: '2Sp05tZUHnNEdOcq1Oc7dyNuYfZ2',
    //   user: User(
    //     id: '2Sp05tZUHnNEdOcq1Oc7dyNuYfZ2',
    //     email: 'iniakunnyaraflirayhan@gmail.com',
    //     phoneNumber: '081213564203',
    //     photoUrl:
    //         'https://lh3.googleusercontent.com/a/ACg8ocKJm_6eNbzvSTmfMPDk37zMaNuYeff1Ou5kn4UaKnWESw5MRo0=s96-c',
    //     starRating: 0,
    //     username: 'Flee',
    //     address: const GeoPoint(0, 0),
    //     // Dummy address
    //     completedFoodTypes: {
    //       'drinks': 0,
    //       'fruitsVeg': 0,
    //       'snacks': 0,
    //       'staple': 0,
    //       'total': 0,
    //     },
    //     orderHistory: {},
    //     purchases: [],
    //     sales: [],
    //   ),
    //   distance: 329.82258828461005,
    //   formattedDistance: '330 m',
    // );

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
          pageBuilder: (context, state) {
            return createSlideFromTopTransitionPage(
              page: const MainScreen(),
            );
          },
          routes: [
            GoRoute(
              path: 'addFood',
              pageBuilder: (context, state) {
                return createSlideFromBottomTransitionPage(
                  page: const AddFoodScreen(),
                );
              },
              routes: [
                GoRoute(
                  path: 'locationPicker',
                  pageBuilder: (context, state) {
                    return createSlideFromBottomTransitionPage(
                      page: const LocationPickerScreen(),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'foodDetail',
              pageBuilder: (context, state) {
                final FoodPost post = state.extra as FoodPost;
                return createSlideFromBottomTransitionPage(
                  page: FoodDetailScreen(post: post),
                );
              },
            ),
            GoRoute(
              path: 'imageFullScreen',
              pageBuilder: (context, state) {
                final String imageUrl = state.extra as String;
                return createSlideFromBottomTransitionPage(
                  page: ImageFullScreenView(imageUrl: imageUrl),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
