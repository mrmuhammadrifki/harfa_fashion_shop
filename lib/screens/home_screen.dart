import 'package:chatting_app/screens/history_screen.dart';
import 'package:chatting_app/screens/product_screen.dart';
import 'package:chatting_app/screens/profil_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: (selected) {
          setState(() {
            _bottomNavIndex = selected;
          });
        },
      ),
    );
  }

  final List<Widget> _listWidget = [
    const ProductScreen(),
    const HistoryScreen(),
    const ProfilScreen()
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Beranda",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: "Riwayat",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: "Akun",
    ),
  ];
}
