import 'package:flutter/material.dart';
import 'package:homestay_host/src/common/splash_screen.dart';
import 'package:homestay_host/src/features/auth/screens/login_screen.dart';
import 'package:homestay_host/src/features/auth/screens/sign_up_screen.dart';
import 'package:homestay_host/src/features/dashboard/screens/home_screen.dart';
import 'package:homestay_host/src/features/homestay/domain/models/homestay_model.dart';
import 'package:homestay_host/src/features/homestay/screens/create_listing.dart';
import 'package:homestay_host/src/features/homestay/screens/listing_screen.dart';
import 'package:homestay_host/src/features/homestay/screens/service_detail_screen.dart';
import 'package:homestay_host/src/features/homestay/screens/update_homestay.dart';
import 'package:homestay_host/src/features/profile/screens/profile_edit_screen.dart';
import 'package:homestay_host/src/features/profile/screens/profile_screen.dart';
import 'package:homestay_host/src/features/profile/screens/support_screen.dart';

class Routes {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String createListingRoute = '/create-listing';
  static const String serviceDetailRoute = '/service-detail';
  static const String myListingRoute = '/my-listing';
  static const String updateListingRoute = '/update-listing';
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
      case Routes.createListingRoute:
        return MaterialPageRoute(builder: (_) => const CreateListingScreen());
      case Routes.myListingRoute:
        return MaterialPageRoute(builder: (_) => const ListingScreen());
      case Routes.serviceDetailRoute:
        final args = settings.arguments as HomestayModel;
        return MaterialPageRoute(
          builder: (_) => ServiceDetailScreen(args),
        );
      case Routes.updateListingRoute:
        final args = settings.arguments as HomestayModel;
        return MaterialPageRoute(
          builder: (_) => UpdateHomestayScreen(homestay: args),
        );
      case Routes.profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.profileEditRoute:
        return MaterialPageRoute(builder: (_) => const ProfileEditScreen());
      case Routes.supportRoute:
        return MaterialPageRoute(builder: (_) => const SupportScreen());
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
