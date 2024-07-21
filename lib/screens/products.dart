import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigations/bottom_bars.dart';
import '../navigations/custom_drawer.dart';


class ProductsScreen extends StatefulWidget {
  final VoidCallback onProductsChanged;

  const ProductsScreen({Key? key, required this.onProductsChanged}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Products> products = [];
  bool isGridMode = false;
  String currentRoute = '/products'; // Default route
  String userName = 'Default User'; // Default user name
  String avatarUrl = 'assets/default_avatar.png'; // Default avatar URL

  // Predefined products
  final List<Products> predefinedProducts = [
    Products(name: 'Product A', price: 100.0, picture: ''),
    Products(name: 'Product B', price: 150.0, picture: ''),
    Products(name: 'Product C', price: 120.0, picture: ''),
    Products(name: 'Product D', price: 90.0, picture: ''),
    Products(name: 'Product E', price: 180.0, picture: ''),
    Products(name: 'Product F', price: 130.0, picture: ''),
    Products(name: 'Product G', price: 110.0, picture: ''),
    Products(name: 'Product H', price: 95.0, picture: ''),
    Products(name: 'Product I', price: 210.0, picture: ''),
    Products(name: 'Product J', price: 70.0, picture: ''),
    Products(name: 'Product K', price: 125.0, picture: ''),
    Products(name: 'Product L', price: 155.0, picture: ''),
    Products(name: 'Product M', price: 85.0, picture: ''),
    Products(name: 'Product N', price: 145.0, picture: ''),
    Products(name: 'Product O', price: 115.0, picture: ''),
    Products(name: 'Product P', price: 190.0, picture: ''),
    Products(name: 'Product Q', price: 105.0, picture: ''),
    Products(name: 'Product R', price: 225.0, picture: ''),
    Products(name: 'Product S', price: 140.0, picture: ''),
    Products(name: 'Product T', price: 175.0, picture: ''),
    // Add more products here
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedProducts();
    _fetchUserDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context)?.settings.name;
      if (route != null) {
        setState(() {
          currentRoute = route;
        });
      }
    });
  }

  Future<void> _loadSavedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedProductsJson = prefs.getStringList('products') ?? [];
    List<Products> savedProducts = Products.listFromJson(savedProductsJson);

    setState(() {
      products = [...predefinedProducts, ...savedProducts]; // Merge predefined and saved products
    });
  }

  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productsJson =
        products.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList('products', productsJson);
    widget.onProductsChanged(); // Notify changes
  }

  Future<void> _fetchUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Default User';
      avatarUrl = prefs.getString('avatarUrl') ?? 'assets/default_avatar.png';
    });
  }

  void _handleRouteChanged(String routeName) {
    setState(() {
      currentRoute = routeName;
    });
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.green, // Primary color
        actions: <Widget>[
          IconButton(
            icon: Icon(
              isGridMode ? Icons.list : Icons.grid_on,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isGridMode = !isGridMode;
              });
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        currentRoute: currentRoute,
        onRouteChanged: _handleRouteChanged,
      ),
      body: _buildBody(),
      bottomNavigationBar: const MyBottomNavigationBar(currentRoute: '/products',), // Add the bottom navigation bar here
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green, // Primary color
        elevation: 10.0,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showAddItemDialog(context);
        },
      ),
    );
  }

  Widget _buildBody() {
    if (isGridMode) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(context, index);
        },
      );
    } else {
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductTile(context, index);
        },
      );
    }
  }

  Widget _buildProductCard(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            child: products[index].picture.isNotEmpty
                ? Image.network(
                    products[index].picture,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.shopping_bag,
                    size: 100,
                    color: Colors.grey,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              products[index].name,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Text(
            '₱${products[index].price.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, int index) {
    return ListTile(
      leading: products[index].picture.isNotEmpty
          ? Image.network(
              products[index].picture,
              width: 50,
              fit: BoxFit.cover,
            )
          : Icon(
              Icons.shopping_bag,
              size: 50,
              color: Colors.grey,
            ),
      title: Text(
        products[index].name,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Text(
        '₱${products[index].price.toStringAsFixed(2)}',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
      onTap: () {
        _showEditItemDialog(context, index);
      },
    );
  }

  Future<void> _showAddItemDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController pictureController = TextEditingController(); // Added for picture URL

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: pictureController, // URL input
                decoration: InputDecoration(labelText: 'Picture URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0.0;
                final picture = pictureController.text;

                setState(() {
                  products.add(Products(name: name, price: price, picture: picture));
                  _saveProducts();
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditItemDialog(BuildContext context, int index) async {
    TextEditingController nameController = TextEditingController(text: products[index].name);
    TextEditingController priceController = TextEditingController(text: products[index].price.toString());
    TextEditingController pictureController = TextEditingController(text: products[index].picture); // Added for picture URL

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: pictureController, // URL input
                decoration: InputDecoration(labelText: 'Picture URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0.0;
                final picture = pictureController.text;

                setState(() {
                  products[index] = Products(name: name, price: price, picture: picture);
                  _saveProducts();
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class Products {
  final String name;
  final double price;
  final String picture;

  Products({required this.name, required this.price, required this.picture});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'picture': picture,
    };
  }

  static List<Products> listFromJson(List<String> jsonList) {
    return jsonList
        .map((jsonString) => Products.fromJson(jsonDecode(jsonString)))
        .toList();
  }

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      name: json['name'],
      price: json['price'],
      picture: json['picture'],
    );
  }
}
