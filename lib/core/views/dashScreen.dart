import 'package:event_session/config/themes/app_themes.dart';
import 'package:flutter/material.dart';

import '../../config/app_assets.dart';
import 'eventDetailPage.dart';
import 'eventPage.dart';
import 'reviewPage.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({super.key});

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  int _selectedIndex = 2;
  final List<Widget> _pages = [
    Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
    EventPage(),
    ReviewsPage(),
    Center(child: Text('Chat Page', style: TextStyle(fontSize: 24))),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(200),
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: _buildCustomBottomNavBar(),
        ),
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Color(0xFFFFF9EF)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(index: 0, iconPath: AppAssets.home, label: 'Search'),
          _buildNavItem(index: 1, iconPath: AppAssets.feed, label: 'Feed'),
          _buildNavItem(index: 2, iconPath: AppAssets.event, label: 'Event'),
          _buildNavItem(
            index: 3,
            iconPath: AppAssets.contact,
            label: 'Contact',
          ),
          _buildNavItem(index: 4, iconPath: AppAssets.chat, label: 'Chat'),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: SizedBox(
        height: 73,
        width: 63,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône avec animation de taille
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  // BoxShadow(
                  //   color: isSelected
                  //       ? AppThemes.secondaryColor.withOpacity(0.4)
                  //       : Colors.transparent,
                  //   offset: Offset(0, isSelected ? 5 : 0),
                  //   blurRadius: isSelected ? 8 : 0,
                  //   spreadRadius: 0,
                  // ),
                  BoxShadow(
                    color: isSelected
                        ? AppThemes.secondaryColor.withOpacity(0.6)
                        : Colors.transparent,
                    offset: const Offset(
                      0,
                      6,
                    ), // Directement en bas, pas sur les côtés
                    blurRadius: isSelected ? 8 : 0, // Flou léger
                    spreadRadius:
                        -4, // Contracte l'ombre pour qu'elle soit plus centrée
                  ),
                ],
              ),
              child: Image.asset(
                iconPath,
                fit: BoxFit.cover,
                height: 28,
                width: 28,
                color: isSelected
                    ? AppThemes.secondaryColor
                    : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            // Label avec animation de couleur
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppThemes.secondaryColor
                    : Colors.grey.shade600,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
