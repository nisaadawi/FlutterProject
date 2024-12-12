import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:http/http.dart' as http;

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  late double screenWidth, screenHeight;
  File? _image;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
       appBar: AppBar(
        title: Text(
            "Add Product",
            style: GoogleFonts.lexendTera(
              color: const Color.fromARGB(252, 255, 255, 255),
              fontSize: 28,
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
        iconTheme: const IconThemeData(
        color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg/productappbar.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
        ),
        toolbarHeight: 120,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            elevation: 20, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded edges
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0), // Reduced padding inside the card
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
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
                                      ? const AssetImage("assets/images/camera.png")
                                      : FileImage(_image!) as ImageProvider),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey),
                            ),
                            height: screenHeight * 0.3, // Reduced height for the image
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        TextFormField(
                          validator: (value) => value!.isEmpty ? "Enter Product Name" : null,
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Product Name",
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: Icon(Icons.production_quantity_limits, color: Theme.of(context).colorScheme.secondary),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                validator: (value) => value!.isEmpty ? "Enter Price" : null,
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Price",
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  prefixIcon: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.secondary),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                validator: (value) => value!.isEmpty ? "Enter Quantity" : null,
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Quantity",
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  prefixIcon: Icon(Icons.add_shopping_cart, color: Theme.of(context).colorScheme.secondary),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        TextFormField(
                          validator: (value) => value!.isEmpty ? "Enter Description" : null,
                          controller: descriptionController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            labelText: "Product Description",
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: Icon(Icons.description, color: Theme.of(context).colorScheme.secondary),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        MaterialButton(
                          elevation: 10,
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            if (_image == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Please take photo"),
                                backgroundColor: Colors.red,
                              ));
                              return;
                            }
                            double filesize = getFileSize(_image!);

                            if (filesize > 100) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Image size too large"),
                                backgroundColor: Colors.red,
                              ));
                              return;
                            }
                            insertProductDialog();
                          },
                          minWidth: screenWidth,
                          height: 45,
                          color: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Add curve with a desired radius
                          ),
                          child: Text(
                            "Insert",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
    // print("BEFORE CROP: ");
    // print(getFileSize(_image!));
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
      if (croppedFile != null){
        File imageFile = File(croppedFile.path);
        _image = imageFile;
        print(getFileSize(_image!));
        setState(() {});
      }
    }

double getFileSize(File file) {
  int sizeInBytes = file.lengthSync();
  double sizeInKB = (sizeInBytes / (1024 * 1024)) * 1000;
  return sizeInKB;
  }
  
  void insertProductDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text(
            "Insert Product",
            style: TextStyle(),
          ),
          content: const Text("Are you sure ?",style: TextStyle()),
          actions: [
            TextButton(
              onPressed: (){
                insertProduct();
                Navigator.of(context).pop();
              }, 
              child: const Text("Yes", style: TextStyle()),
            ),
            TextButton(
              child:  Text(
                "No",
                style: const TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
  }
  
  void insertProduct() {
      String name = nameController.text;
      String price = priceController.text;
      String quantity = quantityController.text;
      String description = descriptionController.text;
      String image = base64Encode(_image!.readAsBytesSync());
      
    http.post(
          Uri.parse("${MyConfig.servername}/memberlink/api/insert_product.php"),
          body: {
            "name": name,
            "price": price,
            "quantity": quantity,
            "description": description,
            "image": image
          }).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          // log(response.body);
          if (data['status'] == "success") {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Insert Success"),
              backgroundColor: Colors.green,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Insert Failed"),
              backgroundColor: Colors.red,
            ));
          }
        }else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Server Error: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ));
      }
    }).catchError((error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $error"),
        backgroundColor: Colors.red,
      ));
    });
  }
}