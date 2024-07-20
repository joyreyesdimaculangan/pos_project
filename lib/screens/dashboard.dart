import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../navigations/bottom_bars.dart'; 
import '../navigations/custom_drawer.dart'; 

class MyLineChart extends StatelessWidget {
  final List<charts.Series<LinearSales, int>> seriesList;
  final bool animate;

  MyLineChart(this.seriesList, {this.animate = true}); // Default value for animate

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(
      seriesList,
      animate: animate,
    );
  }
}

// Pie Chart Widget
class MyPieChart extends StatelessWidget {
  final List<charts.Series<PieSegment, String>> seriesList;
  final bool animate;

  MyPieChart(this.seriesList, {this.animate = true}); // Default value for animate

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      seriesList,
      animate: animate,
    );
  }
}

// Bar Chart Widget
class MyBarChart extends StatelessWidget {
  final List<charts.Series<BarSales, String>> seriesList;
  final bool animate;

  MyBarChart(this.seriesList, {this.animate = true}); // Default value for animate

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Color.fromRGBO(84, 179, 44, 0.525),
      ),
      drawer: CustomDrawer(
        currentRoute: '/dashboard',
        onRouteChanged: (route) {
          Navigator.pushReplacementNamed(context, route);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                padding: EdgeInsets.only(bottom: 16.0),
                child: MyLineChart(_createSampleDataLine()),
              ),
              Container(
                height: 300,
                padding: EdgeInsets.only(bottom: 16.0),
                child: MyPieChart(_createSampleDataPie()),
              ),
              Container(
                height: 300,
                padding: EdgeInsets.only(bottom: 16.0),
                child: MyBarChart(_createSampleDataBar()),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(currentRoute: '/dashboard',), // Add the bottom navigation bar here
    );
  }

  // Sample data for Line Chart
  static List<charts.Series<LinearSales, int>> _createSampleDataLine() {
    final data = [
      LinearSales(0, 5),
      LinearSales(1, 25),
      LinearSales(2, 100),
      LinearSales(3, 75),
    ];

    return [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  // Sample data for Pie Chart
  static List<charts.Series<PieSegment, String>> _createSampleDataPie() {
    final data = [
      PieSegment('A', 35),
      PieSegment('B', 25),
      PieSegment('C', 15),
      PieSegment('D', 25),
    ];

    return [
      charts.Series<PieSegment, String>(
        id: 'Segments',
        domainFn: (PieSegment segment, _) => segment.label,
        measureFn: (PieSegment segment, _) => segment.value,
        data: data,
        labelAccessorFn: (PieSegment segment, _) => '${segment.label}: ${segment.value}',
      )
    ];
  }

  // Sample data for Bar Chart
  static List<charts.Series<BarSales, String>> _createSampleDataBar() {
    final data = [
      BarSales('2014', 5),
      BarSales('2015', 25),
      BarSales('2016', 100),
      BarSales('2017', 75),
    ];

    return [
      charts.Series<BarSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (BarSales sales, _) => sales.year,
        measureFn: (BarSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

// Data models
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class PieSegment {
  final String label;
  final int value;

  PieSegment(this.label, this.value);
}

class BarSales {
  final String year;
  final int sales;

  BarSales(this.year, this.sales);
}
