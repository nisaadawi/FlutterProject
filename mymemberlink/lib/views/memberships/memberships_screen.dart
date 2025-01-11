import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:mymemberlink/views/shared/drawer_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MembershipsScreen extends StatefulWidget {
  const MembershipsScreen({super.key});

  @override
  State<MembershipsScreen> createState() => _MembershipsScreenState();
}

class _MembershipsScreenState extends State<MembershipsScreen> {
  List<dynamic> membershiplist = [];
  late double screenWidth, screenHeight;
  String? adminEmail;
  String? member_type;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      adminEmail = prefs.getString("email");
    });
    if (adminEmail != null) {
        loadMembershipData();
    }
  }

  Future<void> loadMembershipData() async {
    if (adminEmail == null) return;

    final response = await http.post(
      Uri.parse("${MyConfig.servername}/memberlink/api/load_membership.php"),
      body: {'admin_email': adminEmail!},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response data: $data'); // Debug print
      if (data['status'] == 'success') {
        setState(() {
          member_type = data['member_type'];
        });
      } else {
        print('Error: ${data['message']}');
      }
    } else {
      print('Server error');
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final appBarHeight = isPortrait ? 145.0 : 90.0; // Set height 
    final childAspectRatio = isPortrait ? 0.75 : 1.2;

    return Scaffold(
      drawer: const MainScreenDrawer(),
      appBar: AppBar(
        title: Text(
          "Memberships",
          style: GoogleFonts.lexendTera(
            color: const Color.fromARGB(252, 255, 255, 255),
            fontSize: 25.5,
            fontWeight: FontWeight.bold,
            shadows: [
              const Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
                color: Color.fromARGB(128, 65, 3, 87),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              //loadMembershipData();
            },
            icon: const Icon(
              Icons.refresh_outlined,
              color: Colors.white,
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg/memberships.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
        ),
        toolbarHeight: appBarHeight,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(219, 255, 255, 255),
              Color.fromARGB(219, 214, 178, 241),
              Color.fromARGB(255, 80, 17, 148)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.deepPurple,
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: Column(
                            children:[
                              Row(
                                children: [
                                  Text(
                                    "",
                                    style: GoogleFonts.lexendTera(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    member_type ?? "Not Available",
                                    style: GoogleFonts.lexendTera(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ] 
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
           
      ),
    );
  }
}