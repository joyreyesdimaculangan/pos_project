import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_project/user.dart'; // Import your user class
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late User currentUser; // User variable to hold current user info

  bool _showPassword = false; // State variable to toggle password visibility
  bool _showCurrentPassword = false; // State variable to toggle current password visibility
  bool _isHoveringButton = false; // State variable to track hover state

  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _avatarUrlController; // Controller for avatar URL

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _avatarUrlController = TextEditingController();
    _fetchUserInfo();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  void _fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = User(
        username: prefs.getString('username') ?? 'juandelacruz',
        email: prefs.getString('email') ?? 'juan@example.com',
        name: prefs.getString('name') ?? 'Juan dela Cruz',
        password: prefs.getString('password') ?? 'password123',
        avatarUrl: prefs.getString('avatarUrl') ?? '', // Default to empty string
      );
      _usernameController.text = currentUser.username;
      _nameController.text = currentUser.name;
      _emailController.text = currentUser.email;
      _avatarUrlController.text = currentUser.avatarUrl;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    String emailRegex =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // Basic email regex pattern
    RegExp regex = RegExp(emailRegex);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    String passwordRegex = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regex = RegExp(passwordRegex);
    if (!regex.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
    }
    return null;
  }

  String? _validateCurrentPassword(String? value) {
    if (value != currentUser.password) {
      return 'Current password does not match';
    }
    return null;
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Update currentUser with changes
      currentUser.name = _nameController.text;
      currentUser.email = _emailController.text;
      currentUser.avatarUrl = _avatarUrlController.text;
      String newPassword = _newPasswordController.text;
      if (newPassword.isNotEmpty) {
        currentUser.password = newPassword;
      }
      

      // Save updated details to SharedPreferences (simulated)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', currentUser.name);
      prefs.setString('email', currentUser.email);
      // Update password only if newPassword is not empty
      if (newPassword.isNotEmpty) {
        prefs.setString('password', currentUser.password);
      }
      prefs.setString('avatarUrl', currentUser.avatarUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account details updated')),
      );
    }
  }

  void _showAvatarDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Avatar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: currentUser.avatarUrl.isNotEmpty
                    ? NetworkImage(currentUser.avatarUrl)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _avatarUrlController,
                decoration: const InputDecoration(
                  labelText: 'Avatar URL',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  currentUser.avatarUrl = _avatarUrlController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
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
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200, // Adjust height as needed
                child: Center(
                  child: Text(
                    "Account Settings",
                    style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: _showAvatarDialog,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: currentUser.avatarUrl.isNotEmpty
                        ? NetworkImage(currentUser.avatarUrl)
                        : const AssetImage('assets/default_avatar.png') as ImageProvider,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        validator: _validateEmail,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: !_showCurrentPassword,
                        validator: _validateCurrentPassword,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showCurrentPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _showCurrentPassword = !_showCurrentPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: !_showPassword,
                        validator: _validatePassword,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                              color: _isHoveringButton
                                  ? Colors.green
                                  : Colors.transparent,
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _isHoveringButton
                                  ? Colors.green
                                  : Colors.white,
                              backgroundColor: _isHoveringButton
                                  ? Colors.white
                                  : const Color(0xDB3CB607),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _saveChanges,
                            child: Text(
                              'Save',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
