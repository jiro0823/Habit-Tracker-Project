// lib/components/custom_bottom_nav.dart

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class ButtomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ButtomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      color: Colors.deepPurple.shade300,
      buttonBackgroundColor: Colors.deepPurple,
      animationDuration: const Duration(milliseconds: 300),
      index: currentIndex,
      items: const [
        Icon(Icons.home_outlined, size: 30, color: Colors.white),
        Icon(Icons.list_alt, size: 30, color: Colors.white),
        Icon(Icons.add, size: 30, color: Colors.white),
        Icon(Icons.person_outline, size: 30, color: Colors.white),
        Icon(Icons.settings_outlined, size: 30, color: Colors.white),
      ],
      onTap: onTap,
    );
  }
}
