import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'products.dart'; // Ensure this import is correct

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String _userName = 'Juan dela Cruz';
  String _avatarUrl = 'assets/default_avatar.png';
  List<Products> products = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? 'Juan dela Cruz';
      _avatarUrl = prefs.getString('avatarUrl') ?? 'assets/default_avatar.png';
      List<String>? productJsonList = prefs.getStringList('products');
      if (productJsonList != null) {
        products = Products.listFromJson(productJsonList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(84, 179, 44, 0.525),
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
                                backgroundImage: products[index].picture.isNotEmpty
                                    ? NetworkImage(products[index].picture)
                                    : null,
                                child: products[index].picture.isEmpty
                                    ? Icon(Icons.shopping_bag)
                                    : null,
                              ),
                              title: Text(
                                products[index].name,
                                style: GoogleFonts.poppins(color: Colors.black),
                              ),
                              subtitle: Text(
                                '\$${products[index].price.toStringAsFixed(2)}',
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(84, 179, 44, 0.525),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(_avatarUrl),
                    radius: 30,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _userName,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductsScreen(
                      onProductsChanged: _fetchUserData, // Pass callback to refresh data
                    ),
                  ),
                );
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
                Navigator.pushReplacementNamed(context, '/logout');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Products {
  final String name;
  final double price;
  final String picture;

  Products({required this.name, required this.price, this.picture = ''});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'picture': picture,
    };
  }

  static List<Products> listFromJson(List<String> jsonList) {
    return jsonList.map((json) {
      Map<String, dynamic> data = jsonDecode(json);
      return Products(
        name: data['name'],
        price: data['price'],
        picture: data['picture'],
      );
    }).toList();
  }
}