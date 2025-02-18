import 'package:flutter/material.dart';

import '../features/cart/presentation/screens/cart_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';


class BottomNavBarApp extends StatefulWidget {
  const BottomNavBarApp({Key? key}) : super(key: key);

  @override
  _BottomNavBarAppState createState() => _BottomNavBarAppState();
}

class _BottomNavBarAppState extends State<BottomNavBarApp> {
  int _currentIndex = 0;

  // Using an IndexedStack preserves state on each tab.
  final List<Widget> _screens = const [
    HomeScreen(),
    CartScreen(),
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
        onTap: (selectedIndex) {
          setState(() {
            _currentIndex = selectedIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
        ],
      ),
    );
  }
}
