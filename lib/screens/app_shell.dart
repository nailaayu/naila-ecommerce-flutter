import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/shop_controller.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopController>();
    final pages = const [HomeScreen(), OrdersScreen(), ProfileScreen()];
    final isEnglish = shop.language == 'English';
    final titles = [
      'NAILA E-COMMERCE',
      isEnglish ? 'ORDER' : 'ORDER',
      isEnglish ? 'PROFILE' : 'PROFIL',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: isEnglish ? 'HOME' : 'BERANDA'),
          const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'ORDER'),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: isEnglish ? 'PROFILE' : 'PROFIL'),
        ],
      ),
    );
  }
}
