import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'products.dart'; 
import '../navigations/bottom_bars.dart';
import '../navigations/custom_drawer.dart';

// Define the SalesTransaction class if not already defined
class SalesTransaction {
  final String productName;
  final double price;
  final String date;

  SalesTransaction({required this.productName, required this.price, required this.date});

  factory SalesTransaction.fromJson(Map<String, dynamic> json) {
    return SalesTransaction(
      productName: json['productName'],
      price: json['price'],
      date: json['date'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentRoute = '/home'; // Current route to synchronize

  String? _avatarUrl;
  String? _userName;
  List<Products> products = []; // Define the products list
  List<SalesTransaction> salesTransactions = []; // Define the sales transactions list

  double totalSalesAmount = 0.0;
  int totalSalesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProducts(); // Load products when the screen initializes
    _fetchSalesData(); // Load sales data
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarUrl = prefs.getString('avatarUrl') ?? 'https://example.com/default-avatar.png';
      _userName = prefs.getString('name') ?? 'Guest';
    });
  }

  Future<void> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      products = Products.listFromJson(prefs.getStringList('products') ?? []);
    });
  }

  Future<void> _fetchSalesData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalSalesAmount = prefs.getDouble('totalSalesAmount') ?? 0.0;
      totalSalesCount = prefs.getInt('totalSalesCount') ?? 0;

      // Load sales transactions data
      final salesData = prefs.getStringList('salesTransactions') ?? [];
      salesTransactions = salesData.map((data) {
        final json = jsonDecode(data);
        return SalesTransaction.fromJson(json);
      }).toList();
    });
  }

  void _onProductsChanged() {
    _loadProducts(); // Reload products when changed
  }

  

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifications'),
          content: Text('No new notifications'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateTo(String route) {
    setState(() {
      _currentRoute = route;
    });
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = screenHeight * 0.25; // Adjust this factor as needed

    return Scaffold(
      body: Column(
        children: [
          // AppBar
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              child: Container(
                height: appBarHeight, // Responsive height
                width: double.infinity, // Full width of the screen
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: appBarHeight * 0.2), // Adjust vertical padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start, // Align items to the start (left)
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: appBarHeight * 0.25, // Adjust size relative to AppBar height
                          backgroundImage: NetworkImage(_avatarUrl ?? ''),
                        ),
                        SizedBox(width: 12), // Adjust spacing between avatar and text
                        Expanded(
                          child: Text(
                            '$_userName',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: appBarHeight * 0.1, // Adjust text size relative to AppBar height
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis, // Ensure text fits
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.notifications, color: Colors.white),
                      onPressed: _showNotificationDialog, // Show notification dialog
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8), // Adjust space between AppBar and the next content
          // Main content of the screen
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding for content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Overview text
                  Text(
                    '  Overview',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 30, // Adjust text size as needed
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Space below the Overview text
                  // Transactions and Sales Cards
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0), // Add margin to cards
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0), // Adjust padding inside the card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transactions',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 16, // Smaller text size
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '$totalSalesCount', // Display the number of transactions
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
                          margin: const EdgeInsets.symmetric(horizontal: 8.0), // Add margin to cards
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0), // Adjust padding inside the card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sales',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 16, // Smaller text size
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '₱${totalSalesAmount.toStringAsFixed(2)}', // Display total sales amount
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
                  // Products Card
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0), // Add margin to card
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0), // Adjust padding inside the card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Products',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 16, // Smaller text size
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
                                      radius: 20, // Smaller leading avatar
                                      backgroundImage: products[index].picture.isNotEmpty
                                          ? NetworkImage(products[index].picture)
                                          : null,
                                      child: products[index].picture.isEmpty
                                          ? Icon(Icons.shopping_bag, size: 20) // Adjust icon size
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
          ),
        ],
      ),
      drawer: CustomDrawer(
        currentRoute: _currentRoute,
        onRouteChanged: _navigateTo,
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentRoute: _currentRoute,
      ),
    );
  }
}
