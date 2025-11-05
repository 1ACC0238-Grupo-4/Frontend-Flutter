import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF689F38), 
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.black87,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 28,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.home, 0),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.event_note, 1),
          label: 'Reservas',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.search, 2),
          label: 'Buscar',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.chat_bubble_outline, 3),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.person, 4),
          label: 'Perfil',
        ),
      ],
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    final bool isSelected = currentIndex == index;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected 
            ? const Color(0xFFE8F48C) // Light yellow when selected
            : const Color(0xFF8BC34A), // Light green when not selected
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.black87,
      ),
    );
  }
}