import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'home_screen.dart';
import 'discover_screen.dart';
import 'mythology_screen.dart';
import 'language_screen.dart';

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    DiscoverScreen(),
    MythologyScreen(),
    LanguageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: _screens[_index],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 24, offset: const Offset(0, 8)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: NavigationBar(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                backgroundColor: Colors.transparent,
                elevation: 0,
                indicatorColor: AppColors.saffronOrange.withValues(alpha: 0.15),
                height: 64,
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.saffronOrange);
                  }
                  return const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary);
                }),
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home_outlined, color: AppColors.textSecondary), selectedIcon: Icon(Icons.home, color: AppColors.saffronOrange), label: 'Home'),
                  NavigationDestination(icon: Icon(Icons.explore_outlined, color: AppColors.textSecondary), selectedIcon: Icon(Icons.explore, color: AppColors.saffronOrange), label: 'Explore'),
                  NavigationDestination(icon: Icon(Icons.auto_stories_outlined, color: AppColors.textSecondary), selectedIcon: Icon(Icons.auto_stories, color: AppColors.saffronOrange), label: 'Mythology'),
                  NavigationDestination(icon: Icon(Icons.translate_outlined, color: AppColors.textSecondary), selectedIcon: Icon(Icons.translate, color: AppColors.saffronOrange), label: 'Language'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
