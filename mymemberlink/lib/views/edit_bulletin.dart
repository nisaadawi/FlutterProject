
import 'package:flutter/material.dart';
import 'package:mymemberlink/models/bulletin.dart';

class EditBulletinScreen extends StatefulWidget {
  final Bulletin bulletin;

  const EditBulletinScreen({super.key, required this.bulletin});

  @override
  State <EditBulletinScreen> createState() =>  _EditBulletinScreenState();
}

class  _EditBulletinScreenState extends State <EditBulletinScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  
  late double screenHeight, screenWidht;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidht = MediaQuery.of(context).size.width;
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Bulletin"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "New Title"
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: screenHeight *0.7,
                child: TextField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "New Details..."
                  ),
                  maxLines: screenHeight ~/ 35,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                elevation: 10,
                onPressed: onUpdateBulletinDialog,
                minWidth: screenWidht,
                height: 50,
                color: Colors.blue[800],
                child: const Text("Update Bulletin",
                style: TextStyle(
                  color: Colors.white
                ),))
            ],
          ),
          ),
      ),
    );
  }

  void onUpdateBulletinDialog() {
  }
}