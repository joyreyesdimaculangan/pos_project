import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login.dart';
import 'screens/registration.dart';
import 'screens/dashboard.dart';
import 'screens/sales.dart';
import 'screens/products.dart';
import 'screens/account.dart';
import 'screens/home.dart';
import 'screens/intro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Define constant route names
  static const String introRoute = '/intro';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String mainRoute = '/main';
  static const String dashboardRoute = '/dashboard';
  static const String salesRoute = '/sales';
  static const String productsRoute = '/products';
  static const String accountRoute = '/account';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: introRoute,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black),
        ),
      ),
      routes: {
        introRoute: (context) => IntroScreen(),
        loginRoute: (context) => const LoginScreen(),
        registerRoute: (context) => const RegisterScreen(),
        mainRoute: (context) => const MyWidget(),
        dashboardRoute: (context) => DashboardScreen(),
        salesRoute: (context) => SalesScreen(),
        productsRoute: (context) => ProductsScreen(
          onProductsChanged: () {
            // Define what should happen when products change
          },
        ),
        accountRoute: (context) => AccountScreen(),
      },
      onGenerateRoute: (settings) {
        // Handle logout route
        if (settings.name == '/logout') {
          return MaterialPageRoute(builder: (context) => const LoginScreen());
        }
        return null;
      },
    );
  }
}
