import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final String currentRoute;

  const MyBottomNavigationBar({Key? key, required this.currentRoute}) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  final Map<int, String> _routeMap = {
    0: '/home',
    1: '/dashboard',
    2: '/sales',
    3: '/products',
  };

  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedIndex = _routeMap.entries
        .firstWhere((entry) => entry.value == widget.currentRoute, orElse: () => MapEntry(0, '/home'))
        .key;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    String routeName = _routeMap[index]!;
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.green.withOpacity(0.5),
      selectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 173, 196, 173).withOpacity(0.6),
      ),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 24),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, size: 24),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money, size: 24),
          label: 'Sales',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag, size: 24),
          label: 'Products',
        ),
      ],
    );
  }
}
