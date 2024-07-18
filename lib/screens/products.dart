import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = []; // List to store products
  bool isGridMode = false; // Flag to toggle between grid and list view

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

  Widget _buildBody() {
    if (products.isEmpty) {
      return Center(
        child: Text('No items added yet.'),
      );
    } else {
      return isGridMode ? _buildGridView() : _buildListView();
    }
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(products[index].name),
          subtitle: Text('\$${products[index].price.toStringAsFixed(2)}'),
          leading: CircleAvatar(
            backgroundImage: products[index].picture.isNotEmpty
                ? NetworkImage(products[index].picture)
                : null,
            child: products[index].picture.isEmpty
                ? Icon(Icons.shopping_bag)
                : null,
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: products[index].picture.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(products[index].picture),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: products[index].picture.isEmpty
                      ? Icon(Icons.shopping_bag)
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(products[index].name),
                    Text('\$${products[index].price.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context) {
    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemPriceController = TextEditingController();
    TextEditingController itemPictureController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: itemNameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: itemPriceController,
                  decoration: InputDecoration(labelText: 'Item Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: itemPictureController,
                  decoration:
                      InputDecoration(labelText: 'Item Picture URL (Optional)'),
                ),
              ],
            ),
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
                String itemName = itemNameController.text;
                double itemPrice =
                    double.tryParse(itemPriceController.text) ?? 0.0;
                String itemPicture = itemPictureController.text;

                // Add item to list
                setState(() {
                  products.add(
                    Product(name: itemName, price: itemPrice, picture: itemPicture),
                  );
                });

                // Optionally, show a snackbar or perform any other action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Item added: $itemName')),
                );

                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Product {
  final String name;
  final double price;
  final String picture;

  Product({required this.name, required this.price, this.picture = ''});
}
