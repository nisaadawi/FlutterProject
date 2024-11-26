  import 'dart:convert';

  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'package:mymemberlink/models/bulletin.dart';
  import 'package:http/http.dart' as http;
  import 'package:mymemberlink/myconfig.dart';

  class EditBulletinScreen extends StatefulWidget {
    final Bulletin bulletin;

    const EditBulletinScreen({super.key, required this.bulletin});

    @override
    State <EditBulletinScreen> createState() =>  _EditBulletinScreenState();
  }

  class  _EditBulletinScreenState extends State <EditBulletinScreen> {
    TextEditingController titleController = TextEditingController();
    TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.bulletin.bulletinTitle.toString();
    detailsController.text = widget.bulletin.bulletinDetails.toString();
    
  }  
    late double screenHeight, screenWidht;
    @override
    Widget build(BuildContext context) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidht = MediaQuery.of(context).size.width;

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Bulletin",
            style: TextStyle(
              color:Colors.white, 
              fontSize: 22, fontWeight: 
              FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade200],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                              hintText: "Enter new title",
                              labelText: "Title",
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: detailsController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              hintText: "Enter new details...",
                              labelText: "Details",
                            ),
                            maxLines: screenHeight ~/ 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: MaterialButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      onPressed: () {
                        onUpdateBulletinDialog();
                      },
                      height: 50,
                      minWidth: screenWidht * 0.8,
                      color: Theme.of(context).primaryColor,
                      child: const Text(
                        "Update Bulletin",
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    void onUpdateBulletinDialog() {
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: const Text("Update Bulletin"),
            content: const Text("Are you sure to update the bulletin?"),
            actions: [
              TextButton(
                onPressed: (){
                  updateBulletin();
                  Navigator.of(context).pop();
                }, 
                child: const Text("Yes")),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child:  const Text("No"))
            ],
          );
        });
    }
    
    void updateBulletin() {
      String title = titleController.text.toString();
      String details = detailsController.text.toString();
      String date = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // Check if title or details were edited
       // ignore: unused_local_variable
       bool isEdited = (title != widget.bulletin.bulletinTitle) || (details != widget.bulletin.bulletinDetails);
      
      http.post(
        Uri.parse("${MyConfig.servername}/memberlink/api/update_bulletin.php"),
        body: {
          "bulletinid": widget.bulletin.bulletinId.toString(),
          "title": title,
          "details": details,
          "date": date,
          "isEdited": isEdited ? "1" : "0",
        }).then((response){
          if (response.statusCode == 200) {
              var data = jsonDecode(response.body);
              if (data['status'] == "success") {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Update Success"),
                  backgroundColor: Colors.green,
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Update Failed"),
                  backgroundColor: Colors.red,
                ));
              }} else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Server Error"), backgroundColor: Colors.red),
                );}}).catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Network Error"), backgroundColor: Colors.red),
              );
            });
          }
        }