import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  String startDateTime = "", endDateTime = "";
  String dropdowndefaultvalue = 'Conference';
  var items = [
    'Conference',
    'Exibition',
    'Seminar',
    'Hackathon',
  ];
  late double screenWidth, screenHeight;
  File? _image;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Event"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4.0, // Adds a shadow for a lifted look
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded edges
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding inside the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showSelectionDialog();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: _image == null
                                    ? const AssetImage(
                                        "assets/images/camera.png")
                                    : FileImage(_image!) as ImageProvider),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey),
                          ),
                          height: screenHeight * 0.4),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Event Title",
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Column(
                        children: [
                          const Text("Select Start Date"),
                          Text(startDateTime.isNotEmpty ? startDateTime : "Not selected"),
                        ],
                      ),
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((selectTime) {
                              if (selectTime != null) {
                                DateTime selectedDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectTime.hour,
                                  selectTime.minute,
                                );
                                var formatter = DateFormat('dd-MM-yyyy hh:mm a');
                                String formattedDate = formatter.format(selectedDateTime);
                                startDateTime = formattedDate.toString();
                                setState(() {
                                });
                              }
                            });
                          }
                        });
                      },
                    ),
                    GestureDetector(
                      child: Column(
                        children: [
                          const Text("Select End Date"),
                          Text(endDateTime.isNotEmpty ? endDateTime : "Not selected"),
                        ],
                      ),
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((selectTime) {
                              if (selectTime != null) {
                                DateTime selectedDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectTime.hour,
                                  selectTime.minute,
                                );
                                var formatter = DateFormat('dd-MM-yyyy hh:mm a');
                                String formattedDate = formatter.format(selectedDateTime);
                                endDateTime = formattedDate.toString();
                                setState(() {
                                });
                              }
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Event Location"
                  ),
                ),
                const SizedBox(height:10),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),

                    ),
                    labelStyle: TextStyle(
                    ),
                  ),
                  value: dropdowndefaultvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(), 
                  onChanged: (String? newValue){},
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "Event Description"
                    ),
                  ),
                  const SizedBox(height: 10),
                  MaterialButton(
                    elevation: 10,
                    onPressed: (){},
                    minWidth: screenWidth,
                    height: 50,
                    color: Theme.of(context).colorScheme.secondary,
                    child: Text(
                      "Insert",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary
                      ),
                    ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void showSelectionDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text(
            "Select from",
            style: TextStyle(),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(screenWidth/4, screenHeight/8)),
                  child: const Text("Gallery"),
                onPressed: () => {
                  Navigator.of(context).pop(),
                  _selectfromGallery(),
                },
              ),
              const SizedBox(
                width: 8,
              ),
             ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(screenWidth/4, screenHeight/8)),
                  child: const Text("Camera"),
                onPressed: () => {
                  Navigator.of(context).pop(),
                  _selectfromCamera(),
                },
              ),
            ],
          ),
        );
      });
  }
  
  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
      );
      // print("BEFORE CROP: ");
      // print(getFileSize(_image!));
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // setState(() {
      // _image = File(pickedFile.path);
      //  });
      cropImage();
    } else {

    }
  }

  Future<void> _selectfromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    print("BEFORE CROP: ");
    print(getFileSize(_image!));
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // setState(() {
      //   _image = File(pickedFile.path);
      // });
      cropImage();
    } else {}
  }
      
  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
           toolbarTitle: 'Please Crop Your Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ]
      );
      if (CroppedFile != null){
        File imageFile = File(croppedFile!.path);
      _image = imageFile;
      print(getFileSize(_image!));
      setState(() {});
      }
  }
  
  Object? getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }
}