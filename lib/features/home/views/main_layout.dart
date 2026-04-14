import 'package:flutter/material.dart';
import 'package:to_do/features/home/views/home_view.dart';
import 'package:to_do/features/home/views/profile_view.dart';
import 'package:to_do/features/home/views/widgets/customs.dart';
import 'package:to_do/features/home/views/widgets/settings_vew.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final List<Widget> pages = [HomeView(), ProfileView(), SettingsView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
