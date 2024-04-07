import 'package:flutter/material.dart';
import 'package:train/core/cache/app_cache.dart';
import 'package:train/main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppCache _cache = AppCache();

  Future<void> _logout() async {
    await _cache.setIsLoggedIn(false);
    await _cache.setUserId("");
    await supabase.auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile Screen"),
            ElevatedButton(
              onPressed: _logout,
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
