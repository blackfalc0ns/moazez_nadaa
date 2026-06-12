import 'package:flutter/material.dart';

import '../../../../core/utils/navigation/custom_bottom_nav_bar.dart';
import '../../../calls/presentation/pages/calls_dashboard_page.dart';
import '../../../messages/presentation/pages/messages_screen.dart';
import '../widgets/app_side_drawer.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [CallsDashboardPage(), MessagesScreen()];

    return Scaffold(
      extendBody: true,
      drawer: AppSideDrawer(
        selectedIndex: _selectedIndex,
        onTabSelected: (index) => setState(() => _selectedIndex = index),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
