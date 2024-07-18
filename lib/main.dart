import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login.dart';
import 'screens/registration.dart';
import 'screens/dashboard.dart';
import 'screens/sales.dart';
import 'screens/products.dart';
import 'screens/account.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Define constant route names
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
      initialRoute: loginRoute, // Set initial route to login
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black),
        ),
      ),
      routes: {
        loginRoute: (context) => const LoginScreen(),
        registerRoute: (context) => const RegisterScreen(),
        mainRoute: (context) => const MyWidget(), // Main app screen after login
        dashboardRoute: (context) => DashboardScreen(), // Remove 'const' if no const constructor
        salesRoute: (context) => SalesScreen(), // Remove 'const' if no const constructor
        productsRoute: (context) => ProductsScreen(), // Remove 'const' if no const constructor
        accountRoute: (context) => AccountScreen(), // Remove 'const' if no const constructor
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



