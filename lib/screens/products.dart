import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {
  final VoidCallback onProductsChanged; // Callback to notify changes

  const ProductsScreen({Key? key, required this.onProductsChanged}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Products> products = [];
  bool isGridMode = false;

  @override
  void initState() {
    super.initState();
    _loadSavedProducts();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(isGridMode ? Icons.list : Icons.grid_on),
            onPressed: () {
              setState(() {
                isGridMode = !isGridMode;
              });
            },
          ),
        ],
      ),
      drawer: _buildDrawer(), // Add drawer to ProductsScreen
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: const Icon(Icons.add),
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
              color: Color.fromRGBO(84, 179, 44, 0.525),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('assets/default_avatar.png'), // Default avatar or replace with user avatar URL
                  radius: 30,
                ),
                SizedBox(height: 8),
                Text(
                  'Juan dela Cruz', // Default name or replace with user name
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Dashboard'),
            leading: const Icon(Icons.dashboard),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          ListTile(
            title: Text('Sales'),
            leading: const Icon(Icons.attach_money),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/sales');
            },
          ),
          ListTile(
            title: Text('Products'),
            leading: const Icon(Icons.shopping_bag),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          ),
          ListTile(
            title: Text('Account'),
            leading: const Icon(Icons.people),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/account');
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/logout');
            },
          ),
        ],
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
            child: Image.network(
              products[index].picture,
              fit: BoxFit.cover,
            ),
          ),
          Text(products[index].name),
          Text('\$${products[index].price.toStringAsFixed(2)}'),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showEditItemDialog(context, index),
              ),
              IconButton(
                icon: Icon(Icons.delete),
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
            ? Icon(Icons.shopping_bag)
            : null,
      ),
      title: Text(products[index].name),
      subtitle: Text('\$${products[index].price.toStringAsFixed(2)}'),
      onTap: () => _showEditItemDialog(context, index),
      trailing: IconButton(
        icon: Icon(Icons.delete),
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
          title: const Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: pictureController,
                decoration: const InputDecoration(labelText: 'Picture URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0.0;
                final picture = pictureController.text;

                setState(() {
                  products.add(Products(name: name, price: price, picture: picture));
                  _saveProducts(); // Save products after adding
                });
                Navigator.of(context).pop();
                widget.onProductsChanged();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
          title: const Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: pictureController,
                decoration: const InputDecoration(labelText: 'Picture URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0.0;
                final picture = pictureController.text;

                setState(() {
                  products[index] = Products(name: name, price: price, picture: picture);
                  _saveProducts(); // Save products after editing
                });
                Navigator.of(context).pop();
                widget.onProductsChanged();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${products[index].name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  products.removeAt(index);
                  _saveProducts(); // Save products after deletion
                });
                Navigator.of(context).pop();
                widget.onProductsChanged();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
