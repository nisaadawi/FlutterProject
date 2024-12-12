import 'package:flutter/material.dart';
import 'package:mymemberlink/views/shared/drawer_main_screen.dart'; // Ensure this path is correct

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainScreenDrawer(), // Attach your drawer here
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg/mainscreenbg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Positioning the menu button
          Positioned(
            top: 20, // Adjust the position
            left: 20,
            child: Builder(
              builder: (BuildContext context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                onPressed: () {
                  // Open the drawer using the correct context
                  Scaffold.of(context).openDrawer(); 
                },
              ),
            ),
          ),
          // Foreground Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 80),
                // Header Section
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bulletins",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Latest Updates",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Main Content Section
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
