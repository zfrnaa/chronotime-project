import 'package:flutter/material.dart';
import '../core/change_password_page.dart';
import '../core/checkout_page.dart';
import '../core/order_confirmation.dart';
import '../menuPage/bills.dart';
import '../menuPage/favourites.dart';
import '../menuPage/order.dart';
import '../menuPage/profile.dart';
import '../models/watch_item.dart';
import '../core/admin_login.dart';
import '../core/admin.dart';
import '../home.dart';
import '../core/login.dart';
import '../core/register.dart';
import '../pages/bag.dart';
import '../pages/help_support.dart';
import '../pages/notifications.dart';
import '../watchDetails/shared_details.dart';
import '../core/verify_email.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/login': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/admin_login': (context) => const AdminLoginPage(),
    '/admin': (context) => const AdminPage(),
    '/verify-email': (context) => const VerifyEmail(),
    '/home': (context) => const HomePage(),
    '/shared_details': (context) {
      final watch = ModalRoute.of(context)!.settings.arguments as WatchItem;
      return SharedDetailsPage(watch: watch);
    },
    '/favourites': (context) => const FavouritesPage(),
    '/bills': (context) => const BillsPage(),
    '/order': (context) => const OrderPage(),
    '/profile': (context) => const ProfilePage(),
    '/cart': (context) => const BagPage(),
    '/checkout': (context) => const CheckoutPage(),
    '/order_confirmation': (context) => const OrderConfirmation(),
    '/notifications': (context) => const NotificationsPage(),
    '/change_password': (context) => const ChangePasswordPage(),
    // '/privacy_policy': (context) => const PrivacyPolicyPage(),
    '/help_support': (context) => const HelpSupportPage(),
  };
}
