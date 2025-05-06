import 'package:flutter/material.dart';
import 'package:homestay_host/src/common/splash_screen.dart';
import 'package:homestay_host/src/features/auth/screens/login_screen.dart';
import 'package:homestay_host/src/features/auth/screens/sign_up_screen.dart';
import 'package:homestay_host/src/features/dashboard/screens/home_screen.dart';

class Routes {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String notificationRoute = '/notification';
  static const String profileRoute = '/profile';
  static const String recentChats = '/recent-chat';
  static const String chatRoute = '/chat';
  static const String supportRoute = '/support';
  static const String profileEditRoute = '/profile-edit';
  static const String searchRoute = '/search';
  static const String paymentHistoryRoute = '/payment-history';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Invalid Route')),
            body: const Center(child: Text('Route does not exist')),
          ),
    );
  }
}
