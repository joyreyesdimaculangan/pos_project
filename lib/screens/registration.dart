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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Step 1: Define GlobalKey

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  void _performRegistration() async {
    // Simulate registration logic (replace with your actual logic)
    String username = _usernameController.text;
    String email = _emailController.text;
    String name = _nameController.text;
    String password = _passwordController.text;

    // Store credentials in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('name', name);
    await prefs.setString('password', password);

    // Navigate to login screen after successful registration
    Navigator.pushReplacementNamed(context, MyApp.loginRoute);
=======
  // Validation function for the form fields
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Regular expression for email validation
    String pattern =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // RFC 2822 compliant regex
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

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
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                child: Stack(
                  children: <Widget>[
                    Positioned(
<<<<<<< HEAD
                      right: 0,
                      top: 0,
                      width: 400,
                      height: 300,
                      child: FadeInUp(
                        duration: Duration(seconds: 1),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/decor-1.png'),
                            ),
=======
                      right: 10,
                      top: 0,
                      width: 300,
                      height: 300,
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
<<<<<<< HEAD
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Welcome!",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
=======
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "Register",
                            style: GoogleFonts.poppins(
                              color: Colors.green,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
>>>>>>> 393f8b137c276157a009ad9cda342fc2dc02bd38
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
<<<<<<< HEAD
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromRGBO(156, 251, 143, 0.164),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(152, 251, 143, 0.458),
                              blurRadius: 20.0,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(159, 251, 143, 0.606),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Username",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(159, 251, 143, 0.606),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(159, 251, 143, 0.606),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Full Name",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: Container(
=======
                child: Form( // Step 2: Wrap with Form widget
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField( // Step 3: Add TextFormField for username
                        controller: _usernameController,
                        validator: _validateUsername, // Validation function
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField( // Step 3: Add TextFormField for email
                        controller: _emailController,
                        validator: _validateEmail, // Validation function
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField( // Step 3: Add TextFormField for name
                        controller: _nameController,
                        validator: _validateName, // Validation function
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                        ),
                      ),
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
                          onPressed: _performRegistration,
=======
                          onPressed: () {
                            // Validate form on button press
                            if (_formKey.currentState!.validate()) {
                              // If form is valid, proceed with register logic
                              Navigator.pushReplacementNamed(context, MyApp.loginRoute);
                            }
                          },
>>>>>>> 393f8b137c276157a009ad9cda342fc2dc02bd38
                          child: Text(
                            "Register",
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
                          // Navigate to the login screen
                          Navigator.pushNamed(context, MyApp.loginRoute);
                        },
                        child: Text(
                          "Login",
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
