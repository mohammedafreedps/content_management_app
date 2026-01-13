import 'package:content_managing_app/screen/home_nav_screens/add_media/add_media.dart';
import 'package:content_managing_app/screen/home_nav_screens/dashboard/dashboard_screen.dart';
import 'package:content_managing_app/screen/home_nav_screens/review/review_screen.dart';
import 'package:content_managing_app/services/firebase_funtions/current_user_role.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _dashboardKey = GlobalKey<NavigatorState>();
  final _reviewKey = GlobalKey<NavigatorState>();
  final _addKey = GlobalKey<NavigatorState>();

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    _tabs = [
      _buildTab(_dashboardKey, const DashboardScreen()),
      _buildTab(_reviewKey, const ReviewScreen()),
      _buildTab(_addKey, const AddMediaScreen()),
    ];
  }

  Widget _buildTab(GlobalKey<NavigatorState> key, Widget root) {
    return Navigator(
      key: key,
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => root),
    );
  }

  Future<bool> _onWillPop() async {
    final navigator = [
      _dashboardKey,
      _reviewKey,
      _addKey,
    ][_currentIndex];

    if (navigator.currentState!.canPop()) {
      navigator.currentState!.pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _tabs),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: CurrentUserRole.instance.listenable,
          builder: (context, role, _) {
            final items = <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.view_kanban),
                label: 'Re-view',
              ),
              if (CurrentUserRole.instance.isAdmin)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Add Media',
                ),
            ];

            return BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
              },
              type: BottomNavigationBarType.fixed,
              items: items,
            );
          },
        ),
      ),
    );
  }
}
