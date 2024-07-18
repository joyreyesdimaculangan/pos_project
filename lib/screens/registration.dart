import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  String _errorMessage = '';
  bool _isHoveringButton = false; // State variable for register button hover
  bool _isHoveringLogin = false; // State variable for login text hover
  bool _showPassword = false; // State variable to toggle password visibility
  bool _showConfirmPassword = false; // State variable to toggle confirm password visibility

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _performRegistration() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String name = _nameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (!_validateInputs()) {
      setState(() {
        _errorMessage = 'Please fill out all fields correctly.';
      });
      return;
    }

    if (!_isEmail(email)) {
      setState(() {
        _errorMessage = 'Please enter a valid email address.';
      });
      return;
    }

    if (!_isStrongPassword(password)) {
      setState(() {
        _errorMessage = 'Password must be at least 8 characters long and contain a mix of uppercase, lowercase, and digits.';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    // Store credentials in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('name', name);
    await prefs.setString('password', password);

    // Navigate to login screen after successful registration
    Navigator.pushReplacementNamed(context, MyApp.loginRoute);
  }

  bool _validateInputs() {
    return _usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  bool _isEmail(String email) {
    String emailRegex =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // Basic email regex pattern
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    // Password must be at least 8 characters long and contain a mix of uppercase, lowercase, and digits
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
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
                        labelText: 'Username',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        if (!_isEmail(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
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
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
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
                        labelText: 'Full Name',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        if (!_isStrongPassword(value)) {
                          return 'Password must be at least 8 characters long and contain a mix of uppercase, lowercase, and digits.';
                        }
                        return null;
                      },
                      obscureText: !_showPassword,
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
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Confirm Password is required';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      obscureText: !_showConfirmPassword,
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
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _showConfirmPassword = !_showConfirmPassword;
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
                            backgroundColor: _isHoveringButton ? Color.fromARGB(255, 255, 255, 255) : Color(0xDB3CB607),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _performRegistration,
                          child: Text(
                            "Register",
                            style: GoogleFonts.poppins(
                              color: _isHoveringButton ? Colors.green : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, MyApp.loginRoute);
                      },
                      child: MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            _isHoveringLogin = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _isHoveringLogin = false;
                          });
                        },
                        child: Text(
                          "Already have an account? Login here",
                          style: GoogleFonts.poppins(
                            color: _isHoveringLogin ? Colors.green : Color.fromRGBO(50, 115, 22, 0.522),
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
