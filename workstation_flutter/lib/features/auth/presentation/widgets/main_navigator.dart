import 'package:flutter/material.dart';
import 'package:workstation_flutter/features/chats/presentation/chats_page.dart';
import 'package:workstation_flutter/features/home/presentation/home_page.dart';
import 'package:workstation_flutter/features/offices/presentation/offices_page.dart';
import 'package:workstation_flutter/features/profile/presentation/profile_page.dart';
import 'package:workstation_flutter/features/search/presentation/search_page.dart';
import 'package:workstation_flutter/features/auth/presentation/widgets/bottom_nav_bar_widget.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          OfficesPage(),
          SearchPage(),
          ChatsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}