import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:train/core/cache/app_cache.dart';
import 'package:train/core/constants/app_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppCache _cache = AppCache();
  @override
  void initState() {
    if (_cache.getIsLoggedIn() == true) {
      // SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
      // Navigator.pushReplacementNamed(context, '/home');
      // });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LottieBuilder.asset(AppImage.splash),
      ),
    );
  }
}
