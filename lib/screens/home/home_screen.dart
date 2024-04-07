import 'package:flutter/material.dart';
import 'package:train/core/constants/app_color.dart';
import 'package:train/core/styles/style.dart';
import 'package:train/screens/home/home_view_screen.dart';
import 'package:train/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeViewScreen(),
    Container(color: Colors.blue),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_num), label: "Ticket"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        selectedLabelStyle: Style.body14.copyWith(fontWeight: FontWeight.w500),
        unselectedLabelStyle: Style.body12,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.greyAccentDark,
        showUnselectedLabels: true,
      ),
    );
  }
}
