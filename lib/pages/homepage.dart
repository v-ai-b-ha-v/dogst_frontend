import 'package:dogst_ui/pages/timespent.dart';
import 'package:flutter/material.dart';
import 'package:dogst_ui/pages/dashboard.dart';
import 'package:dogst_ui/pages/leaderboard.dart';
import 'package:dogst_ui/pages/settings.dart';
import 'package:google_nav_bar/google_nav_bar.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [Dashboard(), LeaderboardPage(), TimeSpentPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: GNav(
          backgroundColor: Colors.transparent,
          color: Colors.grey[600],
          activeColor: Colors.purple,
          tabBackgroundColor: Colors.purple.shade50,
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(icon: Icons.dashboard, text: 'Dashboard'),
            GButton(icon: Icons.leaderboard, text: 'Leaderboard'),
            GButton(icon: Icons.access_time, text: 'Time spent'),
          ],
        ),
      ),
    );
  }
}
