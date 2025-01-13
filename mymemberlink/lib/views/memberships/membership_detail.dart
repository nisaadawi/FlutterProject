import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymemberlink/models/admin.dart';
import 'package:mymemberlink/models/mymembership.dart';
import 'package:mymemberlink/views/memberships/membership_screen.dart';
import 'package:mymemberlink/views/payments/payment_screen.dart';

class MembershipDetail extends StatefulWidget {
  final MyMembership myMembership;
  final Admin admin;
  const MembershipDetail({super.key, required this.myMembership, required this.admin});

  @override
  State<MembershipDetail> createState() => _MembershipDetailState();
}

class _MembershipDetailState extends State<MembershipDetail> {
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  late double screenWidth, screenHeight;
  String? adminEmail;

  @override
  void initState() {
    super.initState();
     emailController.text = widget.admin.adminemail ?? '';
     print('Admin Email: ${widget.admin.adminemail}');
  }
  

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final appBarHeight = isPortrait ? 145.0 : 90.0;

    return Scaffold(
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
              //loadMemberData();
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
         leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (content) =>  MembershipScreen(admin: widget.admin,))); // Go back to the previous screen
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
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
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Checkout",
                        style: GoogleFonts.montserrat(
                          fontSize: 40.0,
                          color: const Color.fromARGB(255, 127, 0, 200),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Complete your membership details",
                        style: GoogleFonts.montserrat(
                          fontSize: 18.0,
                          color: const Color.fromARGB(255, 230, 192, 6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Card(
                    shadowColor: Colors.purpleAccent.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
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
                        borderRadius: BorderRadius.circular(
                            12.0), // Matches Card border radius
                      ),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.myMembership.membershipName ??
                                      'No Name',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24.0,
                                    color: Colors.white,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'RM ${widget.myMembership.price ?? 'No Price'}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 30.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' / ${widget.myMembership.duration ?? 'No Duration'}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12.0,
                                      color: Colors.white70,
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
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Benefits",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  formatSplit(widget.myMembership.benefits ??
                                      'No Benefits'),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15.0,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Terms & Conditions",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  formatSplit(
                                      widget.myMembership.terms ?? 'No tnc'),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15.0,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Navigator.push(context, MaterialPageRoute(builder: (content) => MembershipScreen(admin: widget.admin))); // Go back to the previous screen
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10.0,
                                      ),
                                    ),
                                    child: Text(
                                      "Change Plan",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14.0,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.purpleAccent.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Details",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 90, 0, 150),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Account Information",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 90, 0, 150),
                            ),
                          ),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email_outlined,
                                  color: Color.fromARGB(255, 90, 0, 150)),
                              hintText: "Email",
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 90, 0, 150)),
                            ),
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "Enter a valid email"
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Billing Address",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 90, 0, 150),
                            ),
                          ),
                          TextFormField(
                            controller: addressController,
                            keyboardType: TextInputType.streetAddress,
                            maxLines: 5,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.house_outlined,
                                  color: Color.fromARGB(255, 90, 0, 150)),
                              hintText: "Address",
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 90, 0, 150)),
                            ),
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "Enter a valid email"
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (content) => PaymentScreen(myMembership: widget.myMembership))); // Go back to the previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(240, 230, 189, 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                  ),
                  child: Text(
                    "Continue Payment",
                    style: GoogleFonts.montserrat(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatSplit(String str) {
    List<String> lines = str.split('\n');
    return lines.map((line) => '⭐ $line').join('\n');
  }
  
}
