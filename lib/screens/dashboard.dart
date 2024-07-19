import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart'; // Import your HomeScreen
import 'sales.dart'; // Import other screens as needed
import 'products.dart'; // Import other screens as needed
import 'account.dart'; // Import other screens as needed
import 'login.dart'; // Import your LoginScreen

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Color.fromRGBO(84, 179, 44, 0.525),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(84, 179, 44, 0.525),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/default_avatar.png'),
                    radius: 30,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'User Name',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Home',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              leading: const Icon(Icons.home),
              onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              title: Text(
                'Dashboard',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              leading: const Icon(Icons.dashboard),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            ListTile(
              title: Text(
                'Sales',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              leading: const Icon(Icons.attach_money),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/sales');
              },
            ),
            ListTile(
              title: Text(
                'Products',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              leading: const Icon(Icons.shopping_bag),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/products');
              },
            ),
            ListTile(
              title: Text(
                'Account',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              leading: const Icon(Icons.people),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/account');
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              leading: const Icon(Icons.logout),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Dashboard Content',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
