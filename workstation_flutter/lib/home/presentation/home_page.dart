import 'package:flutter/material.dart';
import 'package:workstation_flutter/chats/presentation/chats_page.dart';
import 'package:workstation_flutter/offices/presentation/offices_page.dart';
import 'package:workstation_flutter/profile/presentation/profile_page.dart';
import 'package:workstation_flutter/search/presentation/search_page.dart';
import 'package:workstation_flutter/shared/presentation/widgets/bottom_nav_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    Widget page;
    switch (index) {
      case 0:
        return; // Already on this page
      case 1:
        page = const OfficesPage();
        break;
      case 2:
        page = const SearchPage();
        break;
      case 3:
        page = const ChatsPage();
        break;
      case 4:
        page = const ProfilePage();
        break;
      default:
        return;
    }
      Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with wave decoration
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF8BC34A),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.elliptical(200, 30),
                  bottomRight: Radius.elliptical(200, 30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bienvenido Rodrigo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4E99F), // Light green
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 35,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Reservas section
                    const Text(
                      'Reservas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F48C), // Light yellow
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'No hay reservas activas',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Chats section
                    const Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F48C), // Light yellow
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'No hay mensajes nuevos',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
