import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Components', style: GoogleFonts.poppins()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Overview of the system performance and statistics.',
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sales',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Overview of recent transactions and sales data.',
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Products',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Overview of products available in the inventory.',
                        style: GoogleFonts.poppins(),
                      ),
                      // Add more detailed product overview here
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(84, 179, 44, 0.525),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/image.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Juan dela Cruz',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Dashboard', style: GoogleFonts.poppins()),
              leading: const Icon(Icons.dashboard),
              onTap: () {
                Navigator.pushNamed(context, MyApp.dashboardRoute);
              },
            ),
            ListTile(
              title: Text('Sales', style: GoogleFonts.poppins()),
              leading: const Icon(Icons.attach_money),
              onTap: () {
                Navigator.pushNamed(context, MyApp.salesRoute);
              },
            ),
            ListTile(
              title: Text('Products', style: GoogleFonts.poppins()),
              leading: const Icon(Icons.shopping_bag),
              onTap: () {
                Navigator.pushNamed(context, MyApp.productsRoute);
              },
            ),
            const Divider(),
            ListTile(
              title: Text('Account', style: GoogleFonts.poppins()),
              leading: const Icon(Icons.people),
              onTap: () {
                Navigator.pushNamed(context, MyApp.accountRoute);
              },
            ),
            ListTile(
              title: Text('Logout', style: GoogleFonts.poppins()),
              leading: const Icon(Icons.logout),
              onTap: () {
                Navigator.pushReplacementNamed(context, MyApp.loginRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
