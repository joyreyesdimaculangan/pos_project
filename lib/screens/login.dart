import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
<<<<<<< HEAD
  String _errorMessage = '';
=======
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Step 1: Define GlobalKey
>>>>>>> 393f8b137c276157a009ad9cda342fc2dc02bd38

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  void _performLogin() async {
    // Simulate login validation (replace with your actual logic)
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Retrieve stored credentials from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');

    if (username == storedUsername && password == storedPassword) {
      // Navigate to main screen or perform other actions upon successful login
      Navigator.pushReplacementNamed(context, MyApp.mainRoute);
    } else {
      // Handle failed login attempt
      setState(() {
        _errorMessage = 'Invalid username or password. Please try again.';
      });
    }
=======
  // Validation function for the username or email field
  String? _validateUsernameOrEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email or Username is required';
    }
    // Check if the value is in email format using RegExp
    String emailRegex =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // Basic email regex pattern
    RegExp regex = RegExp(emailRegex);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Validation function for the password field
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
>>>>>>> 393f8b137c276157a009ad9cda342fc2dc02bd38
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(219, 219, 255, 204),
              Color.fromRGBO(253, 255, 237, 0.893),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 400,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 400,
                      height: 300,
<<<<<<< HEAD
                      child: FadeInUp(
                        duration: Duration(seconds: 1),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/decor-1.png'),
                            ),
=======
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/decor-1.png'),
>>>>>>> 393f8b137c276157a009ad9cda342fc2dc02bd38
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      width: 200,
                      height: 200,
<<<<<<< HEAD
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/decor-2.png'),
                            ),
=======
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/decor-2.png'),
>>>>>>> 393f8b137c276157a009ad9cda342fc2dc02bd38
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      width: 400,
                      height: 400,
<<<<<<< HEAD
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: Image.asset('assets/images/character-2.png'),
                      ),
=======
                      child: Image.asset('assets/images/character-2.png'),
>>>>>>> 393f8b137c276157a009ad9cda342fc2dc02bd38
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      width: 300,
                      height: 500,
                      child: Image.asset('assets/images/character-1.png'),
                    ),
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "Welcome!",
                            style: GoogleFonts.poppins(
                              color: Colors.green,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Form( // Step 2: Wrap with Form widget
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField( // Step 3: Add TextFormField for username/email
                        controller: _usernameController,
                        validator: _validateUsernameOrEmail, // Validation function
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email or Phone number',
                        ),
                      ),
<<<<<<< HEAD
                    ),
                    if (_errorMessage.isNotEmpty)
                      SizedBox(height: 20),
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: Container(
=======
                      SizedBox(height: 20),
                      TextFormField( // Step 3: Add TextFormField for password
                        controller: _passwordController,
                        validator: _validatePassword, // Validation function
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
>>>>>>> 393f8b137c276157a009ad9cda342fc2dc02bd38
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xDB3CB607),
                              Color.fromRGBO(84, 179, 44, 0.525),
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
<<<<<<< HEAD
                            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
=======
                            backgroundColor: Colors.transparent,
>>>>>>> 393f8b137c276157a009ad9cda342fc2dc02bd38
                            shadowColor: Colors.transparent,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
<<<<<<< HEAD
                          onPressed: _performLogin,
=======
                          onPressed: () {
                            // Validate form on button press
                            if (_formKey.currentState!.validate()) {
                              // If form is valid, proceed with login logic
                              Navigator.pushReplacementNamed(context, MyApp.mainRoute);
                            }
                          },
>>>>>>> 393f8b137c276157a009ad9cda342fc2dc02bd38
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the registration screen
                          Navigator.pushNamed(context, MyApp.registerRoute);
                        },
                        child: Text(
                          "Don't have an account? Register here",
                          style: GoogleFonts.poppins(
                            color: Color.fromRGBO(50, 115, 22, 0.522),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
