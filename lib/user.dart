// user.dart

class User {
  String username;
  String email;
  String name;
  String password;
  String avatarUrl; // Add this line

  User({
    required this.username,
    required this.email,
    required this.name,
    required this.password,
    this.avatarUrl = '', // Default to an empty string
  });

  // Setters for modifying user information
  set setEmail(String email) {
    this.email = email;
  }

  set setName(String name) {
    this.name = name;
  }

  set setPassword(String password) {
    this.password = password;
  }

  set setAvatarUrl(String avatarUrl) {
    this.avatarUrl = avatarUrl;
  }
}
