import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  // Example list of products
  final List<Product> products = const [
    Product(
      name: 'Product 1',
      description: 'Description of Product 1',
      image: 'assets/product1.jpg',
    ),
    Product(
      name: 'Product 2',
      description: 'Description of Product 2',
      image: 'assets/product2.jpg',
    ),
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
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
                            'Transactions',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '1,2324',
                            style: GoogleFonts.poppins(color: Colors.black),
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
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '15,242',
                            style: GoogleFonts.poppins(color: Colors.black),
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
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(products[index].image),
                              ),
                              title: Text(
                                products[index].name,
                                style: GoogleFonts.poppins(color: Colors.black),
                              ),
                              subtitle: Text(
                                products[index].description,
                                style: GoogleFonts.poppins(color: Colors.black),
                              ),
                            );
                          },
                        ),
                      ),
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
              title: Text('Dashboard', style: GoogleFonts.poppins(color: Colors.black)),
              leading: const Icon(Icons.dashboard),
              onTap: () {
                Navigator.pushNamed(context, MyApp.dashboardRoute);
              },
            ),
            ListTile(
              title: Text('Sales', style: GoogleFonts.poppins(color: Colors.black)),
              leading: const Icon(Icons.attach_money),
              onTap: () {
                Navigator.pushNamed(context, MyApp.salesRoute);
              },
            ),
            ListTile(
              title: Text('Products', style: GoogleFonts.poppins(color: Colors.black)),
              leading: const Icon(Icons.shopping_bag),
              onTap: () {
                Navigator.pushNamed(context, MyApp.productsRoute);
              },
            ),
            const Divider(),
            ListTile(
              title: Text('Account', style: GoogleFonts.poppins(color: Colors.black)),
              leading: const Icon(Icons.people),
              onTap: () {
                Navigator.pushNamed(context, MyApp.accountRoute);
              },
            ),
            ListTile(
              title: Text('Logout', style: GoogleFonts.poppins(color: Colors.black)),
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

class Product {
  final String name;
  final String description;
  final String image;

  const Product({
    required this.name,
    required this.description,
    required this.image,
  });
}
