import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymemberlink/models/admin.dart';
import 'package:mymemberlink/models/mymembership.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:mymemberlink/views/memberships/membership_detail.dart';
import 'package:mymemberlink/views/shared/drawer_main_screen.dart';
import 'package:http/http.dart' as http;

class MembershipScreen extends StatefulWidget {
  final Admin admin;
  const MembershipScreen({super.key, required this.admin});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  List<MyMembership> membershiplist = [];
  late double screenWidth, screenHeight;
  bool isLoading = true;
  String status = "Loading..";

  @override
  void initState() {
    super.initState();
    loadMemberData();
    refreshAdminData();
  }

  Future<void> refreshAdminData() async {
    try {
      final response = await http.get(
        Uri.parse('${MyConfig.servername}/memberlink/api/load_admin.php?admin_email=${widget.admin.adminemail}'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          setState(() {
            widget.admin.membertype = jsonResponse['data']['member_type'];
          });
        }
      }
    } catch (e) {
      print("Error refreshing admin data: $e");
    }
  }

  Widget _buildCurrentMembershipBadge() {
    return InkWell(
      onTap: () {
        if (widget.admin.membertype != null && 
            widget.admin.membertype != 'FREE EXPLORER') {
          _showTerminateDialog();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 192, 107, 241),
              Color.fromARGB(255, 127, 0, 200),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Plan",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.admin.membertype ?? 'No Active Plan',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (widget.admin.membertype != null && 
                      widget.admin.membertype != 'FREE EXPLORER')
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Tap to manage membership',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.star,
                color: Colors.yellow[800],
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final appBarHeight = isPortrait ? 145.0 : 90.0; // Set height

    return Scaffold(
      drawer: MainScreenDrawer(admin: widget.admin),
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
              loadMemberData();
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
              Color.fromARGB(255, 80, 17, 148),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading 
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 127, 0, 200),
                  ),
                ),
              )
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Text(
                  (widget.admin.adminname ?? '').split(' ')
                      .map((word) => word[0].toUpperCase() + word.substring(1))
                      .join(' ') + "'s Membership",
                  style: GoogleFonts.montserrat(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 127, 0, 200),
                  ),
                ),
              ),
              _buildCurrentMembershipBadge(),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose",
                      style: GoogleFonts.montserrat(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 127, 0, 200),
                      ),
                    ),
                    Text(
                      "Available Membership plans for You!",
                      style: GoogleFonts.montserrat(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 230, 192, 6),
                      ),
                    ),
                  ],
                ),
              ),
              membershiplist.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "No Data..",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: membershiplist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 6,
                            shadowColor: Colors.deepPurpleAccent,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 192, 107, 241),
                                    Color.fromARGB(255, 127, 0, 200),
                                    Color.fromARGB(255, 243, 200, 93),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 5, 2, 5),
                                child: ExpansionTile(
                                  title: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            membershiplist[index]
                                                    .membershipName ??
                                                'No Name',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 20.0,
                                              color: Colors
                                                  .white, // Changed to white
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          membershiplist[index].description ??
                                              'No Desc',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12.0,
                                            color:
                                                Colors.white, // Changed to white
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height:5),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'RM ${membershiplist[index].price ?? 'No Price'}',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 28.0,
                                                color: Colors
                                                    .white, // Changed to white
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              ' / ${membershiplist[index].duration ?? 'No Duration'}',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12.0,
                                                color: Colors
                                                    .white, // Changed to white
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Benefits",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16.0,
                                              color: Colors
                                                  .white, // Changed to white
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            formatSplit(
                                                membershiplist[index].benefits ??
                                                    'No Benefits'),
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14.0,
                                              color: Colors
                                                  .white, // Changed to white
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Terms & Conditions",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16.0,
                                              color: Colors
                                                  .white, // Changed to white
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6.0),
                                          Text(
                                            formatSplit(
                                                membershiplist[index].terms ??
                                                    'No tnc'),
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14.0,
                                              color: Colors
                                                  .white, // Changed to white
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                MyMembership myMembership = membershiplist[index];

                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute( builder: (content) =>
                                                   MembershipDetail(myMembership:myMembership,
                                                                     admin: widget.admin),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25.0),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 10.0,
                                                ),
                                              ),
                                              child: Text(
                                                "Select",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 14.0,
                                                  color: Colors.deepPurple,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String formatSplit(String str) {
    // Split the string into lines and add bullet points
    List<String> lines = str.split('\n');
    return lines.map((line) => '⭐ $line').join('\n');
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      return "${str.substring(0, length)}..."; // Truncate with ellipses
    } else {
      return str;
    }
  }

  void loadMemberData() {
    setState(() {
      isLoading = true;
    });

    refreshAdminData().then((_) {
      http.get(Uri.parse("${MyConfig.servername}/memberlink/api/load_member.php"))
          .then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            var result = data['data']['memberships'];

            membershiplist.clear();

            for (var item in result) {
              MyMembership memberships = MyMembership.fromJson(item);
              membershiplist.add(memberships);
            }
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              status = "No Data";
              isLoading = false;
            });
          }
        } else {
          setState(() {
            status = "Error loading data";
            print("Error");
            isLoading = false;
          });
        }
      }).catchError((error) {
        setState(() {
          status = "Error: $error";
          isLoading = false;
        });
      });
    });
  }

  void _showTerminateDialog() {
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
                Icons.warning_amber_rounded,
                size: 50,
                color: Colors.red[700],
              ),
              const SizedBox(height: 10),
              Text(
                'Terminate Membership',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to terminate your current membership?',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  'Your membership will be downgraded to FREE EXPLORER',
                  style: GoogleFonts.montserrat(
                    color: Colors.red[700],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
                Navigator.of(context).pop();
                _terminateMembership();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Terminate',
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

  Future<void> _terminateMembership() async {
    try {
      final response = await http.post(
        Uri.parse('${MyConfig.servername}/memberlink/api/terminate_membership.php'),
        body: {
          'admin_email': widget.admin.adminemail,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          if (mounted) {
            setState(() {
              widget.admin.membertype = 'FREE EXPLORER';
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Membership terminated successfully',
                  style: GoogleFonts.montserrat(),
                ),
                backgroundColor: Colors.green,
              ),
            );
            loadMemberData(); // Reload the membership list
          }
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Server error');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: GoogleFonts.montserrat(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshAdminData();
  }
}
