import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'carix_fuel.dart';
import 'carix_home.dart';
import 'documents_screen.dart';
import 'expense_manager_screen.dart';
import 'settings_screen.dart';
import 'universal_entry_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CarixHomeScreen(),
    const CarixFuelScreen(),
    const ExpenseManagerScreen(),
    const DocumentsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _entryTabForIndex(int index) {
    switch (index) {
      case 1:
        return 'Fuel';
      case 3:
        return 'Docs';
      case 4:
        return 'Service';
      case 2:
      case 0:
      default:
        return 'Overview';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => UniversalEntryScreen(
                initialTab: _entryTabForIndex(_selectedIndex),
              ),
            ),
          );
        },
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.cyan.withValues(alpha: 0.9), AppColors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withAlpha(51), width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withAlpha(76),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 34),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withAlpha(204), // 0.8 opacity
              border: Border(
                top: BorderSide(
                  color: Colors.white.withAlpha(25), // 0.1 opacity
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: _ActiveNavIcon(icon: Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_gas_station_outlined),
                  activeIcon: _ActiveNavIcon(icon: Icons.local_gas_station),
                  label: 'Fuel',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  activeIcon: _ActiveNavIcon(
                    icon: Icons.account_balance_wallet,
                  ),
                  label: 'Expense',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.folder_outlined),
                  activeIcon: _ActiveNavIcon(icon: Icons.folder),
                  label: 'Docs',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: _ActiveNavIcon(icon: Icons.settings),
                  label: 'Settings',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: AppColors.cyan,
              unselectedItemColor: Colors.white.withAlpha(128),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveNavIcon extends StatelessWidget {
  final IconData icon;

  const _ActiveNavIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: AppColors.cyan.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cyan.withAlpha(128), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withAlpha(76),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.cyan),
    );
  }
}
