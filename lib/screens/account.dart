import 'package:flutter/material.dart';
import '../user.dart'; // Import the User class

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Example usage of the User class
  User currentUser = User(
    username: 'juandelacruz',
    email: 'juan@example.com',
    name: 'Juan dela Cruz',
    password: 'password123',
  );

  bool _showPassword = false; // State variable to toggle password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${currentUser.username}'),
            Text('Email: ${currentUser.email}'),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: currentUser.name,
              onChanged: (value) {
                setState(() {
                  currentUser.name = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: currentUser.password,
              onChanged: (value) {
                setState(() {
                  currentUser.password = value;
                });
              },
              obscureText: !_showPassword, // Toggle obscureText based on _showPassword
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
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
            ElevatedButton(
              onPressed: () {
                // Save edited details
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account details updated')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
