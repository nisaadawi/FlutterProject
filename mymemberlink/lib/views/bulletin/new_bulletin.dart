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

 late double screenHeight, screenWidht;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidht = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Bulletin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 210, 232, 249),  const Color.fromARGB(255, 32, 111, 175)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
           child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                            hintText: "Bulletin title",
                            labelText: "Title",) 
                          ),
                        const SizedBox(
                            height: 10),
                        TextField(
                            controller: detailsController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              hintText: "New Details...",
                              labelText:"Details",
                            ),
                          maxLines: screenHeight ~/ 35,
                         ),
                        ],
                      ),
                    ),
                    ),
                  const SizedBox(height: 20,
                  ),
                    Center(
                      child: MaterialButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      onPressed: onInsertBulletinDialog,
                      minWidth: screenWidht * 0.8,
                      height: 50,
                      color: Theme.of(context).primaryColor,
                      child: const Text("Insert",
                          style: TextStyle(
                           color: Colors.white, 
                           fontSize: 16)
                           )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

  void onInsertBulletinDialog() {
    if (titleController.text.isEmpty || detailsController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill in Bulletin title and details..."),
        backgroundColor: Colors.red,
        ));
        return;
    }
    showDialog(context: context, 
    builder: (BuildContext context){
      return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Post Bulletin",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Are you sure to post the news?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                insertBulletin();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:  Text(
                "No",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
  
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
    
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          showCustomDialog(
            context,
            "Success",
            "Successfully add new bulletin!",
            "assets/gif/dribbble-success-2.gif", // Replace with your image or GIF path
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Post Failed.."),
            backgroundColor: Color.fromARGB(255, 198, 46, 46),
          ));
        }
      }
    });
  }
  void showCustomDialog(BuildContext context, String title, String message, String imagePath) {
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