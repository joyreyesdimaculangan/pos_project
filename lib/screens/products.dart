import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    setState(() {
      products = Products.listFromJson(prefs.getStringList('products') ?? []);
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
      drawer: _buildDrawer(),
      body: _buildBody(),
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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green, // Primary color
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 30,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    userName, // User name
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    overflow: TextOverflow.ellipsis, // Ensure text fits
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            text: 'Dashboard',
            routeName: '/dashboard',
          ),
          _buildDrawerItem(
            icon: Icons.attach_money,
            text: 'Sales',
            routeName: '/sales',
          ),
          _buildDrawerItem(
            icon: Icons.shopping_bag,
            text: 'Products',
            routeName: '/products',
          ),
          _buildDrawerItem(
            icon: Icons.people,
            text: 'Account',
            routeName: '/account',
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            routeName: '/logout',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required String routeName,
  }) {
    final bool isActive = currentRoute == routeName;

    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 55, 56, 55)), // Primary color
      title: Text(
        text,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      tileColor: isActive ? const Color.fromARGB(188, 76, 175, 79) : null, // Highlight color
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName);
        setState(() {
          currentRoute = routeName; // Update current route
        });
      },
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
            child: Image.network(
              products[index].picture,
              fit: BoxFit.cover,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '\$${products[index].price.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.green, // Accent color
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green), // Accent color
                onPressed: () => _showEditItemDialog(context, index),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red), // Red for delete
                onPressed: () => _showDeleteConfirmationDialog(context, index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: products[index].picture.isNotEmpty
            ? NetworkImage(products[index].picture)
            : null,
        child: products[index].picture.isEmpty
            ? Icon(Icons.shopping_bag, color: Colors.green) // Accent color
            : null,
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
        '\$${products[index].price.toStringAsFixed(2)}',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 14,
            color: Colors.green, // Accent color
          ),
        ),
      ),
      onTap: () => _showEditItemDialog(context, index),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red), // Red for delete
        onPressed: () => _showDeleteConfirmationDialog(context, index),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final pictureController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Product',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: pictureController,
                decoration: InputDecoration(labelText: 'Picture URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0.0;
                final picture = pictureController.text;

                setState(() {
                  products.add(Products(name: name, price: price, picture: picture));
                  _saveProducts();
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(BuildContext context, int index) {
    final nameController = TextEditingController(text: products[index].name);
    final priceController = TextEditingController(text: products[index].price.toString());
    final pictureController = TextEditingController(text: products[index].picture);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Product',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: pictureController,
                decoration: InputDecoration(labelText: 'Picture URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  products[index] = Products(
                    name: nameController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    picture: pictureController.text,
                  );
                  _saveProducts();
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Product',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  products.removeAt(index);
                  _saveProducts();
                });

                Navigator.of(context).pop();
              },
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

  Products({
    required this.name,
    required this.price,
    required this.picture,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      name: json['name'],
      price: json['price'].toDouble(),
      picture: json['picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'picture': picture,
    };
  }

  static List<Products> listFromJson(List<String> jsonList) {
    return jsonList.map((json) => Products.fromJson(jsonDecode(json))).toList();
  }
}
