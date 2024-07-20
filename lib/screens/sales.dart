import 'package:flutter/material.dart';
import '../navigations/bottom_bars.dart'; 
import '../navigations/custom_drawer.dart';

// Define a class to represent a sales transaction
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

class SalesScreen extends StatefulWidget {
  SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late List<SalesTransaction> filteredTransactions;
  late Map<String, double> totalSales;
  late DateTime startDate;
  late DateTime endDate;

  // Example list of sales transactions
  final List<SalesTransaction> salesTransactions = [
    SalesTransaction(
      date: '2024-07-18',
      time: '10:00 AM',
      productName: 'Product A',
      price: 100.0,
    ),
    SalesTransaction(
      date: '2024-07-18',
      time: '11:30 AM',
      productName: 'Product B',
      price: 150.0,
    ),
    SalesTransaction(
      date: '2024-07-18',
      time: '1:00 PM',
      productName: 'Product C',
      price: 120.0,
    ),
    SalesTransaction(
      date: '2024-07-18',
      time: '3:30 PM',
      productName: 'Product D',
      price: 90.0,
    ),
    SalesTransaction(
      date: '2024-07-18',
      time: '5:00 PM',
      productName: 'Product E',
      price: 180.0,
    ),
    SalesTransaction(
      date: '2024-07-19',
      time: '9:00 AM',
      productName: 'Product F',
      price: 130.0,
    ),
    SalesTransaction(
      date: '2024-07-19',
      time: '10:30 AM',
      productName: 'Product G',
      price: 110.0,
    ),
    SalesTransaction(
      date: '2024-07-19',
      time: '12:00 PM',
      productName: 'Product H',
      price: 95.0,
    ),
    SalesTransaction(
      date: '2024-07-19',
      time: '2:30 PM',
      productName: 'Product I',
      price: 210.0,
    ),
    SalesTransaction(
      date: '2024-07-19',
      time: '4:00 PM',
      productName: 'Product J',
      price: 70.0,
    ),
    SalesTransaction(
      date: '2024-07-20',
      time: '11:00 AM',
      productName: 'Product K',
      price: 125.0,
    ),
    SalesTransaction(
      date: '2024-07-20',
      time: '1:30 PM',
      productName: 'Product L',
      price: 155.0,
    ),
    SalesTransaction(
      date: '2024-07-20',
      time: '3:00 PM',
      productName: 'Product M',
      price: 85.0,
    ),
    SalesTransaction(
      date: '2024-07-20',
      time: '5:30 PM',
      productName: 'Product N',
      price: 145.0,
    ),
    SalesTransaction(
      date: '2024-07-21',
      time: '10:00 AM',
      productName: 'Product O',
      price: 115.0,
    ),
    SalesTransaction(
      date: '2024-07-21',
      time: '12:30 PM',
      productName: 'Product P',
      price: 190.0,
    ),
    SalesTransaction(
      date: '2024-07-21',
      time: '2:00 PM',
      productName: 'Product Q',
      price: 105.0,
    ),
    SalesTransaction(
      date: '2024-07-21',
      time: '4:30 PM',
      productName: 'Product R',
      price: 225.0,
    ),
    SalesTransaction(
      date: '2024-07-22',
      time: '9:30 AM',
      productName: 'Product S',
      price: 140.0,
    ),
    SalesTransaction(
      date: '2024-07-22',
      time: '11:00 AM',
      productName: 'Product T',
      price: 175.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    filteredTransactions = salesTransactions;
    calculateTotalSales();
    startDate = DateTime.now().subtract(Duration(days: 7));
    endDate = DateTime.now();
  }

  // Calculate total sales per transaction
  void calculateTotalSales() {
    totalSales = {};
    salesTransactions.forEach((transaction) {
      totalSales[transaction.date] =
          (totalSales[transaction.date] ?? 0) + transaction.price;
    });
  }

  // Method to filter transactions based on date range
  void filterTransactionsByDateRange(DateTime start, DateTime end) {
    setState(() {
      filteredTransactions = salesTransactions.where((transaction) {
        DateTime transactionDate = DateTime.parse(transaction.date);
        return transactionDate.isAfter(start.subtract(Duration(days: 1))) &&
            transactionDate.isBefore(end.add(Duration(days: 1)));
      }).toList();
    });
  }

  // Method to filter transactions by search query
  void filterTransactions(String query) {
    setState(() {
      filteredTransactions = salesTransactions.where((transaction) =>
          transaction.productName.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final String? result = await showSearch(
                context: context,
                delegate: SalesTransactionSearchDelegate(salesTransactions),
              );
              if (result != null && result.isNotEmpty) {
                filterTransactions(result);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: DateTimeRange(start: startDate, end: endDate),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData(
                      primarySwatch: Colors.green, // Customize your primary color here
                      // Optionally, customize other aspects like text styles
                    ),
                    child: child!,
                  );
                },
              ).then((dateRange) {
                if (dateRange != null) {
                  setState(() {
                    startDate = dateRange.start;
                    endDate = dateRange.end;
                  });
                  filterTransactionsByDateRange(startDate, endDate);
                }
              });
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        currentRoute: '/sales',
        onRouteChanged: (route) {
          Navigator.pushReplacementNamed(context, route);
        },
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              headingRowHeight: 40,
              dataRowHeight: 60,
              dividerThickness: 1,
              columnSpacing: 16,
              columns: const [
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
                    'Price',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Total Sales',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              ],
              rows: filteredTransactions.map((transaction) {
                return DataRow(
                  cells: [
                    DataCell(Text(transaction.date)),
                    DataCell(Text(transaction.time)),
                    DataCell(Text(transaction.productName)),
                    DataCell(Text('\$${transaction.price.toStringAsFixed(2)}')),
                    DataCell(Text('\$${totalSales[transaction.date]!.toStringAsFixed(2)}')),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(currentRoute: '/sales',), // Add the bottom navigation bar here
    );
  }
}

// Search delegate for handling search actions
class SalesTransactionSearchDelegate extends SearchDelegate<String> {
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
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // Build your search results here if needed
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? []
        : transactions.where((transaction) {
            return transaction.productName.toLowerCase().contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].productName),
          onTap: () {
            close(context, suggestionList[index].productName);
          },
        );
      },
    );
  }
}

// Filter transactions by date range dialog
class DateRangePickerDialog extends StatelessWidget {
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final Function(DateTime, DateTime) onDateRangeSelected;

  DateRangePickerDialog({
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onDateRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? startDate = initialStartDate;
    DateTime? endDate = initialEndDate;

    return AlertDialog(
      title: Text('Select Date Range'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Start Date:'),
          SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final pickedStartDate = await showDatePicker(
                context: context,
                initialDate: startDate!,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData(
                      primarySwatch: Colors.green, // Customize your primary color here
                      // Optionally, customize other aspects like text styles
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedStartDate != null) {
                startDate = pickedStartDate;
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: startDate != null ? startDate.toString() : 'Select start date',
              ),
              child: Text(startDate != null ? startDate!.toString() : ''),
            ),
          ),
          SizedBox(height: 16),
          Text('End Date:'),
          SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final pickedEndDate = await showDatePicker(
                context: context,
                initialDate: endDate!,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData(
                      primarySwatch: Colors.green, // Customize your primary color here
                      // Optionally, customize other aspects like text styles
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedEndDate != null) {
                endDate = pickedEndDate;
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: endDate != null ? endDate.toString() : 'Select end date',
              ),
              child: Text(endDate != null ? endDate!.toString() : ''),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (startDate != null && endDate != null) {
              onDateRangeSelected(startDate!, endDate!);
              Navigator.of(context).pop();
            }
          },
          child: Text('Apply'),
        ),
      ],
    );
  }
}