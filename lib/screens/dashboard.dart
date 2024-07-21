import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';
import '../navigations/custom_drawer.dart';
import '../navigations/bottom_bars.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<SalesTransaction> salesTransactions = [];
  Map<String, double>? salesData;

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    final prefs = await SharedPreferences.getInstance();
    final totalAmount = prefs.getDouble('totalSalesAmount') ?? 0.0;
    final totalCount = prefs.getInt('totalSalesCount') ?? 0;

    // Assuming you have a way to fetch all sales transactions as well
    // For this example, it's hardcoded
    salesTransactions = [
      SalesTransaction(date: '2024-07-18', time: '10:00 AM', productName: 'A', price: 100.0),
      SalesTransaction(date: '2024-07-18', time: '11:30 AM', productName: 'B', price: 150.0),
      SalesTransaction(date: '2024-07-18', time: '1:00 PM', productName: 'C', price: 120.0),
      SalesTransaction(date: '2024-07-18', time: '3:30 PM', productName: 'D', price: 90.0),
      SalesTransaction(date: '2024-07-18', time: '5:00 PM', productName: 'E', price: 180.0),
      SalesTransaction(date: '2024-07-19', time: '9:00 AM', productName: 'F', price: 130.0),
      SalesTransaction(date: '2024-07-19', time: '10:30 AM', productName: 'G', price: 110.0),
      // Add more transactions here
    ];

    setState(() {
      salesData = {
        'totalAmount': totalAmount,
        'totalCount': totalCount.toDouble(),
      };
    });
  }

  List<charts.Series<DailySales, DateTime>> _createSalesDataLine() {
    final dailySales = <DateTime, int>{};

    for (var transaction in salesTransactions) {
      final date = DateTime.parse(transaction.date);
      final onlyDate = DateTime(date.year, date.month, date.day);
      dailySales[onlyDate] = (dailySales[onlyDate] ?? 0) + 1;
    }

    final data = dailySales.entries
        .map((entry) => DailySales(entry.key, entry.value))
        .toList();

    return [
      charts.Series<DailySales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DailySales sales, _) => sales.date,
        measureFn: (DailySales sales, _) => sales.count,
        data: data,
      )
    ];
  }

  List<charts.Series<BarSales, String>> _createSampleDataBar() {
    final productSales = <String, int>{};

    for (var transaction in salesTransactions) {
      productSales[transaction.productName] = (productSales[transaction.productName] ?? 0) + 1;
    }

    final data = productSales.entries
        .map((entry) => BarSales(entry.key, entry.value.toDouble()))
        .toList();

    return [
      charts.Series<BarSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (BarSales sales, _) => sales.label,
        measureFn: (BarSales sales, _) => sales.value,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      drawer: CustomDrawer(
        currentRoute: '/dashboard',
        onRouteChanged: (route) {
          Navigator.pushReplacementNamed(context, route);
        },
      ),
      body: salesData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First card to display total sales amount
                    _buildTotalAmountCard(),
                    // Line chart card
                    _buildChartCard(
                      title: 'Products Sold Per Day',
                      child: charts.TimeSeriesChart(
                        _createSalesDataLine(),
                        animate: true,
                        // Additional chart configuration
                      ),
                    ),
                    // Bar chart card
                    _buildChartCard(
                      title: 'Sales Bar Chart',
                      child: charts.BarChart(
                        _createSampleDataBar(),
                        animate: true,
                        // Additional chart configuration
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: MyBottomNavigationBar(currentRoute: '/dashboard'),
    );
  }

  Widget _buildTotalAmountCard() {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Sales Amount',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '₱${salesData?['totalAmount']?.toStringAsFixed(2) ?? '0.00'}',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: child,
          ),
        ],
      ),
    );
  }
}

class DailySales {
  final DateTime date;
  final int count;

  DailySales(this.date, this.count);
}

class BarSales {
  final String label;
  final double value;

  BarSales(this.label, this.value);
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
