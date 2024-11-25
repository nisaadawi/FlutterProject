import 'package:flutter/material.dart';

class MainScreenDrawer extends StatelessWidget {
  const MainScreenDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.white,
                ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            onTap: () {
              // Define onTap actions here if needed
            },
            title: const Text("Newsletter"),
          ),
          const ListTile(
            title: Text("Events"),
          ),
          const ListTile(
            title: Text("Members"),
          ),
          const ListTile(
            title: Text("Payment"),
          ),
          const ListTile(
            title: Text("Product"),
          ),
          const ListTile(
            title: Text("Vetting"),
          ),
          const ListTile(
            title: Text("Settings"),
          ),
        ],
      ),
    );
  }
}