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
  String _errorMessage = '';
  bool _isHoveringButton = false; // State variable for login button hover
  bool _isHoveringRegister = false; // State variable for register text hover
  bool _showPassword = false; // State variable to toggle password visibility

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
  }

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
              Color.fromARGB(255, 255, 255, 255),
              Color.fromRGBO(255, 255, 255, 0.886),
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
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/decor-1.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      width: 200,
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/decor-2.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      width: 400,
                      height: 400,
                      child: Image.asset('assets/images/character-2.png'),
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
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      validator: _validateUsernameOrEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: 'Email or Username',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      validator: _validatePassword,
                      obscureText: !_showPassword, // Toggle password visibility
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty) ...[
                      SizedBox(height: 20),
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                    SizedBox(height: 20),
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHoveringButton = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHoveringButton = false;
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isHoveringButton ? Colors.green : Colors.transparent,
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: _isHoveringButton ? Colors.green : Colors.white,
                            backgroundColor: _isHoveringButton ? Colors.white : Color(0xDB3CB607),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _performLogin,
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, MyApp.registerRoute);
                      },
                      child: MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            _isHoveringRegister = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _isHoveringRegister = false;
                          });
                        },
                        child: Text(
                          "Don't have an account? Register here",
                          style: GoogleFonts.poppins(
                            color: _isHoveringRegister ? Colors.green : Color.fromRGBO(50, 115, 22, 0.522),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
