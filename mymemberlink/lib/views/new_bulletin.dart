import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlink/myconfig.dart';

class NewBulletinScreen extends StatefulWidget {
  const NewBulletinScreen({super.key});

  @override
  State<NewBulletinScreen> createState() => _NewBulletinScreenState();
}

class _NewBulletinScreenState extends State<NewBulletinScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Bulletin"),
      ),
      body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                      hintText: "Bulletin title")
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: detailsController,
                      maxLines: 15,
                      decoration: const InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                      hintText: "What's the Bulletin for today..?")
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                    MaterialButton(
                    elevation: 10,
                    onPressed: onInsertBulletinDialog,
                    minWidth: 400,
                    height: 50,
                    color: Colors.purple[800],
                    child: const Text("Insert",
                        style: TextStyle(color: Colors.white))),
                  ],
                ),
              ),
            ),
      );
  }

  void onInsertBulletinDialog() {
    if (titleController.text.isEmpty || detailsController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill in Bulletin title and details..."),
        ));
        return;
    }
    showDialog(context: context, 
    builder: (BuildContext context){
      return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Post Bulletin",
            style: TextStyle(),
          ),
          content: const Text("Are you sure to post the news?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                insertBulletin();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //   content: Text("Registration Canceled"),
                //   backgroundColor: Colors.red,
                // ));
              },
            ),
          ],
        );
    });
  }
  
  void insertBulletin() {
    String title = titleController.text;
    String details = detailsController.text;
    http.post(
        Uri.parse("${MyConfig.servername}/memberlink/api/insert_news.php"),
        body: {"title": title, "details": details}).then((response) {
      // print(response.statusCode);
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Post Success!"),
            backgroundColor: Color.fromARGB(255, 59, 216, 127),
          ));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Post Failed.."),
            backgroundColor: Color.fromARGB(255, 198, 46, 46),
          ));
        }
      }
    });
  }
}