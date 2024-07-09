import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mealty/common/styles.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:mealty/provider/manage_food_provider.dart';
import 'package:mealty/provider/cart_provider.dart';
import 'package:mealty/provider/food_provider.dart';
import 'package:mealty/provider/notification_provider.dart';
import 'package:mealty/provider/order_provider.dart';
import 'package:mealty/provider/profile_provider.dart';
import 'package:mealty/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'firebase_options.dart';
import 'provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('id_ID', null);

  runApp(
    SkeletonizerConfig(
      data: const SkeletonizerConfigData(
        effect: ShimmerEffect(),
      ),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => FoodProvider()),
          ChangeNotifierProvider(create: (context) => ManageFoodProvider()),
          ChangeNotifierProvider(create: (context) => CartProvider()),
          ChangeNotifierProvider(create: (context) => OrderProvider()),
          ChangeNotifierProvider(create: (context) => NotificationProvider()),
          ChangeNotifierProvider(create: (context) => ProfileProvider())
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = AppRouter.configureRouter();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Mealty',
      theme: lightTheme,
    );
  }
}
