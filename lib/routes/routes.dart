import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/sign_up/sign_up_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/train_detail/train_detail_screen.dart';

Map<String, Widget Function(BuildContext context)> routes = {
  '/': (context) => const SplashScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const SignUpScreen(),
  '/home': (context) => const HomeScreen(),
  '/train_detail': (context) => const TrainDetailScreen(),
};
