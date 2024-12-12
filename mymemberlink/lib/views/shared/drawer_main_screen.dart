import 'package:flutter/material.dart';
import 'package:mymemberlink/views/bulletin/bulletin_screen.dart';
import 'package:mymemberlink/views/events/event_screen.dart';
import 'package:mymemberlink/views/products/product_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreenDrawer extends StatelessWidget {
  const MainScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 80, 17, 148), // Purple background for the drawer
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 80, 17, 148), // Purple color for the header
            ),
            child: Center(
              // child: Text(
              //   'Drawer Header',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.white), // Bulletin icon
            title: Text(
              "Bulletin",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White color for text
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => const BulletinScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.event, color: Colors.white), // Events icon
            title: Text(
              "Events",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White color for text
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => const EventScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.people, color: Colors.white), // Members icon
            title: Text(
              "Members",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White color for text
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.payment, color: Colors.white), // Payment icon
            title: Text(
              "Payment",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White color for text
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits, color: Colors.white), // Product icon
            title: Text(
              "Product",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White color for text
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => const ProductScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.white), // Vetting icon
            title: Text(
              "Vetting",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White color for text
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white), // Settings icon
            title: Text(
              "Settings",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White color for text
              ),
            ),
          ),
        ],
      ),
    );
  }
}
