import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../navigations/bottom_bars.dart'; 
import '../navigations/custom_drawer.dart';

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  String username = 'Default User';
  String avatarUrl = 'assets/default_avatar.png';
  String currentRoute = '/sales';
  DateTimeRange? selectedDateRange;
  List<SalesTransaction> salesTransactions = [];
  List<SalesTransaction> filteredTransactions = [];
  Map<String, double> totalSales = {};

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _fetchSalesTransactions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context)?.settings.name;
      if (route != null) {
        setState(() {
          currentRoute = route;
        });
      }
    });
  }

  Future<void> _fetchUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('name') ?? 'Default User';
      avatarUrl = prefs.getString('avatarUrl') ?? 'assets/default_avatar.png';
    });
  }

  Future<void> _fetchSalesTransactions() async {
    // Simulating data fetch with a static list for now
    salesTransactions = [
      SalesTransaction(date: '2024-07-18', time: '10:00 AM', productName: 'Product A', price: 100.0),
      SalesTransaction(date: '2024-07-18', time: '11:30 AM', productName: 'Product B', price: 150.0),
      SalesTransaction(date: '2024-07-18', time: '1:00 PM', productName: 'Product C', price: 120.0),
      SalesTransaction(date: '2024-07-18', time: '3:30 PM', productName: 'Product D', price: 90.0),
      SalesTransaction(date: '2024-07-18', time: '5:00 PM', productName: 'Product E', price: 180.0),
      SalesTransaction(date: '2024-07-19', time: '9:00 AM', productName: 'Product F', price: 130.0),
      SalesTransaction(date: '2024-07-19', time: '10:30 AM', productName: 'Product G', price: 110.0),
      SalesTransaction(date: '2024-07-19', time: '12:00 PM', productName: 'Product H', price: 95.0),
      SalesTransaction(date: '2024-07-19', time: '2:30 PM', productName: 'Product I', price: 210.0),
      SalesTransaction(date: '2024-07-19', time: '4:00 PM', productName: 'Product J', price: 70.0),
      SalesTransaction(date: '2024-07-20', time: '11:00 AM', productName: 'Product K', price: 125.0),
      SalesTransaction(date: '2024-07-20', time: '1:30 PM', productName: 'Product L', price: 155.0),
      SalesTransaction(date: '2024-07-20', time: '3:00 PM', productName: 'Product M', price: 85.0),
      SalesTransaction(date: '2024-07-20', time: '5:30 PM', productName: 'Product N', price: 145.0),
      SalesTransaction(date: '2024-07-21', time: '10:00 AM', productName: 'Product O', price: 115.0),
      SalesTransaction(date: '2024-07-21', time: '12:30 PM', productName: 'Product P', price: 190.0),
      SalesTransaction(date: '2024-07-21', time: '2:00 PM', productName: 'Product Q', price: 105.0),
      SalesTransaction(date: '2024-07-21', time: '4:30 PM', productName: 'Product R', price: 225.0),
      SalesTransaction(date: '2024-07-22', time: '9:30 AM', productName: 'Product S', price: 140.0),
      SalesTransaction(date: '2024-07-22', time: '11:00 AM', productName: 'Product T', price: 175.0),
      // Add more transactions here
    ];
    _filterTransactions();
  }

  void _filterTransactions() {
    if (selectedDateRange != null) {
      final start = selectedDateRange!.start;
      final end = selectedDateRange!.end;
      filteredTransactions = salesTransactions.where((transaction) {
        final transactionDate = DateTime.parse(transaction.date);
        return transactionDate.isAfter(start) && transactionDate.isBefore(end);
      }).toList();
    } else {
      filteredTransactions = List.from(salesTransactions);
    }
    _calculateTotalSales();
  }

  void _calculateTotalSales() {
    double totalAmount = 0;
    int totalCount = filteredTransactions.length;
    
    for (var transaction in filteredTransactions) {
      totalAmount += transaction.price;
    }

    // Save to SharedPreferences
    _saveSalesData(totalAmount, totalCount);
  }

  Future<void> _saveSalesData(double totalAmount, int totalCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalSalesAmount', totalAmount);
    await prefs.setInt('totalSalesCount', totalCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SalesTransactionSearchDelegate(salesTransactions),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              final dateRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: selectedDateRange,
              );
              if (dateRange != null) {
                setState(() {
                  selectedDateRange = dateRange;
                  _filterTransactions();
                });
              }
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        currentRoute: currentRoute,
        onRouteChanged: (route) {
          Navigator.pushReplacementNamed(context, route);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: DataTable(
                columns: _buildDataColumns(),
                rows: filteredTransactions.map((transaction) {
                  final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction.date));
                  return DataRow(cells: [
                    DataCell(Text(formattedDate)),
                    DataCell(Text(transaction.time)),
                    DataCell(Text(transaction.productName)),
                    DataCell(Text('₱${transaction.price.toStringAsFixed(2)}')),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(currentRoute: currentRoute), // Add the bottom navigation bar here
    );
  }

  List<DataColumn> _buildDataColumns() {
    return [
      DataColumn(
        label: Text(
          'Date',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
      DataColumn(
        label: Text(
          'Time',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
      DataColumn(
        label: Text(
          'Product',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
      DataColumn(
        label: Text(
          'Price (₱)',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
    ];
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required String routeName,
  }) {
    final bool isActive = currentRoute == routeName;

    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 55, 56, 55)),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName);
      },
    );
  }
}

class SalesTransaction {
  final String date;
  final String time;
  final String productName;
  final double price;

  SalesTransaction({
    required this.date,
    required this.time,
    required this.productName,
    required this.price,
  });
}

class SalesTransactionSearchDelegate extends SearchDelegate<SalesTransaction?> {
  final List<SalesTransaction> transactions;

  SalesTransactionSearchDelegate(this.transactions);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = transactions.where((transaction) {
      return transaction.productName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView(
      children: results.map((transaction) {
        return ListTile(
          title: Text(transaction.productName),
          subtitle: Text('₱${transaction.price.toStringAsFixed(2)}'),
          onTap: () {
            close(context, transaction);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = transactions.where((transaction) {
      return transaction.productName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView(
      children: suggestions.map((transaction) {
        return ListTile(
          title: Text(transaction.productName),
          subtitle: Text('₱${transaction.price.toStringAsFixed(2)}'),
          onTap: () {
            query = transaction.productName;
            showResults(context);
          },
        );
      }).toList(),
    );
  }
}
