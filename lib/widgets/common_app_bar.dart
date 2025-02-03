import 'package:flutter/material.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CommonAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text(widget.title),
      leading: IconButton(
        icon: const Icon(Icons.menu), // Drawer icon
        onPressed: () {
          Scaffold.of(context).openDrawer(); // Open the drawer
        },
      ),
      actions: [
        _buildIconButton(
          context,
          index: 0,
          icon: Icons.gif_box,
          label: 'Giver',
          routeName: '/giver',
        ),
        _buildIconButton(
          context,
          index: 1,
          icon: Icons.volunteer_activism,
          label: 'NGO',
          routeName: '/ngo',
        ),
        _buildIconButton(
          context,
          index: 2,
          icon: Icons.handshake,
          label: 'Donor',
          routeName: '/donor',
        ),
        _buildIconButton(
          context,
          index: 3,
          icon: Icons.person,
          label: 'Profile',
          routeName: '/profile',
        ),
      ],
    );
  }

  Widget _buildIconButton(BuildContext context,
      {required int index,
        required IconData icon,
        required String label,
        required String routeName}) {
    bool isSelected = _selectedIndex == index;

    return IconButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pushNamed(context, routeName);
      },
      icon: AnimatedScale(
        scale: isSelected ? 1.3 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Icon(
          icon,
          color: isSelected ? Colors.yellow : Colors.white,
        ),
      ),
      tooltip: label,
    );
  }
}
