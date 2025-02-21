import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'provider/bag_provider.dart';
import 'provider/favorites_provider.dart';
import 'provider/filter_provider.dart';
import 'provider/order_provider.dart';
import 'core/login.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      'your_stripe_key';
  // await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  // await SyncService().syncWatchItems();
  // await SyncService().syncOrders();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BagProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
          ChangeNotifierProvider(create: (_) => FilterProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
        ],
        child: MaterialApp(
          title: 'Chrono Time',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            fontFamily: GoogleFonts.aDLaMDisplay().fontFamily,
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          home: const FirebaseInitializer(),
          routes: AppRoutes.routes,
        ));
  }
}

class FirebaseInitializer extends StatelessWidget {
  const FirebaseInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: kIsWeb
          ? Firebase.initializeApp(
              options: const FirebaseOptions(
                  apiKey: "your_own_project_apikey",
                  authDomain: "your_own_setup",
                  projectId: "your_own_projectId",
                  storageBucket: "your_own_proj_storage_id",
                  messagingSenderId: "[your_own_messagingSenderId]",
                  appId: "your_own_appId"))
          : Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const LoginPage();
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error initializing Firebase: ${snapshot.error}'),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
