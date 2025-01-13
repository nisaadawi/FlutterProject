import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mymemberlink/models/admin.dart';
import 'package:mymemberlink/models/bulletin.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlink/views/shared/drawer_main_screen.dart';
import 'package:mymemberlink/views/bulletin/edit_bulletin.dart';
import 'package:mymemberlink/views/bulletin/new_bulletin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BulletinScreen extends StatefulWidget {
  final Admin admin;
  BulletinScreen({super.key, required this.admin});

  @override
  State<BulletinScreen> createState() => _BulletinScreen();
}

class _BulletinScreen extends State<BulletinScreen> {
  List<Bulletin> bulletinList = [];
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  int numofpage = 1;
  int currentpage = 1;
  int numofresult = 0;
  late double screenWidth, screenHeight;
  var color;

  Set<String> viewedBulletins = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadViewedBulletins();
    loadBulletinData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bulletin",
          style: GoogleFonts.lexendTera(
            color: const Color.fromARGB(252, 255, 255, 255),
            fontSize: 40,
            fontWeight: FontWeight.bold,
            shadows: [
              const Shadow(
                offset: Offset(2.0, 2.0), // Position of the shadow
                blurRadius: 4.0, // Softness of the shadow
                color: Color.fromARGB(
                    128, 63, 3, 85), // Shadow color with transparency
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), // Make the background transparent
        elevation: 0, // Remove shadow
        actions: [
          IconButton(
            onPressed: () {
              loadBulletinData();
            },
            icon: const Icon(
              Icons.refresh_outlined,
              color: Colors.white,
            ),
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0), // Rounded edges at the bottom
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/bg/bulletinappbar.png'), // Your image here
              fit: BoxFit.cover, // Resize image to cover the area
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30.0), // Same rounded edges as above
            ),
          ),
        ),
        toolbarHeight: 145, // Resize the AppBar height
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
        child: bulletinList.isEmpty
            ? const Center(
                child: Text("No data"),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Page: $currentpage/Result: $numofresult",
                      style: const TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: bulletinList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),
                            child: Card(
                              color: Colors.white,
                              elevation: 5,
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 115, 47, 188),
                                  child: Icon(Icons.newspaper,
                                      color: Colors.white),
                                ),
                                onLongPress: () {
                                  deleteDialog(index);
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      truncateString(
                                          bulletinList[index]
                                              .bulletinTitle
                                              .toString(),
                                          30),
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          df.format(DateTime.parse(
                                              bulletinList[index]
                                                  .bulletinDate
                                                  .toString())),
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (bulletinList[index].isEdited)
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              "Edited",
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        if (!viewedBulletins.contains(
                                            bulletinList[index]
                                                .bulletinId)) // Check if it's new
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 39.0),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 2.0),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                "New",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  truncateString(
                                      bulletinList[index]
                                          .bulletinDetails
                                          .toString(),
                                      150),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  color: Color.fromARGB(255, 178, 78, 255),
                                  onPressed: () {
                                    showBulletinDialog(index);
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numofpage,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        if ((currentpage - 1) == index) {
                          color = Colors.yellow[500];
                        } else {
                          color = Colors.white;
                        }
                        return TextButton(
                            onPressed: () {
                              currentpage = index + 1;
                              loadBulletinData();
                            },
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color, fontSize: 18),
                            ));
                      },
                    ),
                  ),
                ],
              ),
      ),
      drawer: MainScreenDrawer(admin: widget.admin),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 178, 78, 255),
        onPressed: () async {
          await Navigator.push(
              //wait for this to happen
              context,
              MaterialPageRoute(
                  builder: (content) => const NewBulletinScreen()));
          loadBulletinData(); // load back the data
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void loadBulletinData() {
    http
        .get(Uri.parse(
            "${MyConfig.servername}/memberlink/api/load_bulletin.php?pageno=$currentpage"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['bulletin'];

          bulletinList.clear();

          for (var item in result) {
            Bulletin bulletin = Bulletin.fromJson(item);
            bulletinList.add(bulletin);
            
          }
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());

          setState(() {});
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    });
  }

  void deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 243, 246, 251),
            title: Text(
              "Delete \"${truncateString(bulletinList[index].bulletinTitle.toString(), 20)}\"",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            content: const Text("Are you sure to delete this bulletin?"),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteBulletin(index);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  void deleteBulletin(int index) {
    http.post(
        Uri.parse("${MyConfig.servername}/memberlink/api/delete_bulletin.php"),
        body: {
          "bulletinid": bulletinList[index].bulletinId.toString()
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          showCustomDialog(
            context,
            "Success",
            "Successfully deleted the bulletin!",
            "assets/gif/trash-bin.gif", // Replace with your image or GIF path
          );
          loadBulletinData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Failed to delete"), backgroundColor: Colors.red));
        }
      }
    });
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadViewedBulletins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load the list of viewed bulletins (default to empty list if not found)
    List<String> viewedBulletinsList =
        prefs.getStringList('viewedBulletins') ?? [];
    viewedBulletins =
        Set<String>.from(viewedBulletinsList); // Convert List to Set

    setState(() {});
  }

  void markAsViewed(String bulletinId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Add the bulletinId to the set of viewed bulletins
    viewedBulletins.add(bulletinId);

    // Save the updated set as a list
    await prefs.setStringList('viewedBulletins', viewedBulletins.toList());

    setState(() {});
  }

  void showBulletinDialog(int index) {
    markAsViewed(bulletinList[index].bulletinId!);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: const Color.fromARGB(255, 243, 246, 251),
            title: Text(bulletinList[index].bulletinTitle.toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center),
            content: Text(
              bulletinList[index].bulletinDetails.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            actions: [
              const SizedBox(height: 5),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Bulletin bulletin = bulletinList[index];
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) =>
                                EditBulletinScreen(bulletin: bulletin)));
                    loadBulletinData();
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(
                        color: Colors.purple[700],
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  void showCustomDialog(
      BuildContext context, String title, String message, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath, // Image or GIF path
                height: 150, // Adjust size based on your needs
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 15),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "OK",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
