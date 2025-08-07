import 'package:flutter/material.dart';
import 'package:scheduleplanner/create.dart';
import 'package:scheduleplanner/delete.dart';
import 'package:scheduleplanner/home.dart';
import 'package:scheduleplanner/update.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void updateIndex(int index) {
    _onItemTapped(index);
  }

  final List<Widget> _pages = [
    const HomePage(), // shows fetched posts
    const Create(),
    const Update(),
    const Delete(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schedule Planner")),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/home.png'), color: Colors.black),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/create.png'), color: Colors.black),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/update.png'), color: Colors.black),
            label: 'Update',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/delete.png'), color: Colors.black),
            label: 'Delete',
          ),
        ],
      ),
    );
  }
}
