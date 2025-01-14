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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Icon(
                Icons.logout_rounded,
                size: 50,
                color: Colors.red[700],
              ),
              const SizedBox(height: 10),
              Text(
                'Logout',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.montserrat(
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
          const Divider(  // Add a divider before logout
            color: Colors.white24,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded, 
              color: Colors.white,
            ),
            title: Text(
              "Logout",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}
