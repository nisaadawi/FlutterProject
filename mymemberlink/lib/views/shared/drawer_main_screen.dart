import 'package:flutter/material.dart';
import 'package:mymemberlink/models/admin.dart';
import 'package:mymemberlink/views/memberships/membership_screen.dart';
import 'package:mymemberlink/views/bulletin/bulletin_screen.dart';
import 'package:mymemberlink/views/events/event_screen.dart';
import 'package:mymemberlink/views/payments/payment_history.dart';
import 'package:mymemberlink/views/products/product_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreenDrawer extends StatelessWidget {
  final Admin admin;
  const MainScreenDrawer({super.key, required this.admin});  

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
                  MaterialPageRoute(builder: (content) =>  BulletinScreen(admin: admin)));
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
                  MaterialPageRoute(builder: (content) =>  EventScreen(admin: admin)));
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
            ),onTap:() {
              Navigator.push(context, 
                        MaterialPageRoute(builder: (content)=>  MembershipScreen(admin: admin)));
            }
            ),
          ListTile(
            leading: const Icon(Icons.payment, color: Colors.white), // Payment icon
            title: Text(
              "Payment History",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White color for text
              ),
            ),onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) =>  PaymentHistory(admin: admin)));
            },
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
                  MaterialPageRoute(builder: (content) => ProductScreen(admin: admin)));
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
