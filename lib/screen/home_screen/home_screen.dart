import 'package:content_managing_app/screen/home_nav_screens/add_media/add_media.dart';
import 'package:content_managing_app/screen/home_nav_screens/dashboard/dashboard_screen.dart';
import 'package:content_managing_app/screen/home_nav_screens/review/review_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ReviewScreen(),
    AddMediaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_kanban),
            label: 'Re-view',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Media',
          ),
        ],
      ),
    );
  }
}
