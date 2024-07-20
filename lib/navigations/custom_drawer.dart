import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  final String currentRoute;
  final ValueChanged<String> onRouteChanged;

  const CustomDrawer({
    Key? key,
    required this.currentRoute,
    required this.onRouteChanged,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userName = 'Default User';
  String avatarUrl = 'assets/default_avatar.png';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Default User';
      avatarUrl = prefs.getString('avatarUrl') ?? 'assets/default_avatar.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: avatarUrl.startsWith('http')
                      ? NetworkImage(avatarUrl)
                      : AssetImage(avatarUrl) as ImageProvider,
                  radius: 30,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    userName,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            text: 'Home',
            routeName: '/home',
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            text: 'Dashboard',
            routeName: '/dashboard',
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.attach_money,
            text: 'Sales',
            routeName: '/sales',
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.shopping_bag,
            text: 'Products',
            routeName: '/products',
            context: context,
          ),
          Divider(height: 40, color: Colors.grey[300]),
          _buildDrawerItem(
            icon: Icons.people,
            text: 'Account',
            routeName: '/account',
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            routeName: '/logout',
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required String routeName,
    required BuildContext context,
  }) {
    final bool isActive = widget.currentRoute == routeName;

    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 55, 56, 55)),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      tileColor: isActive ? const Color.fromARGB(188, 76, 175, 79) : null,
      onTap: () {
        widget.onRouteChanged(routeName);
        Navigator.pushReplacementNamed(context, routeName);
      },
    );
  }
}
