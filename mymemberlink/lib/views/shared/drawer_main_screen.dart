import 'package:flutter/material.dart';
import 'package:mymemberlink/views/events/event_screen.dart';

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
          ListTile(
            title: const Text("Events"),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (content) => const EventScreen()));
            },
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