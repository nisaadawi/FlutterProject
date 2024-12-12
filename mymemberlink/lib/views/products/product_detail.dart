import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymemberlink/models/myproduct.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlink/views/products/product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final MyProduct myproduct;

  const ProductDetailScreen({super.key, required this.myproduct});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreen();
}

class _ProductDetailScreen extends State<ProductDetailScreen> {
  TextEditingController quantityController = TextEditingController(text: "1");
  late double screenWidth, screenHeight;
  File? _image;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Details",
            style: GoogleFonts.lexendTera(
              color: const Color.fromARGB(252, 255, 255, 255),
              fontSize: 35,
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
            Navigator.push(context, MaterialPageRoute(builder: (content) => ProductScreen())); // Go back to the previous screen
          },
        ),
      ),
      body: Stack(
      children: [
        // Gradient Background
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
        // Scrollable Content with Card
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Card(
              elevation: 20,
              shadowColor: Colors.deepPurple.withOpacity(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          "${MyConfig.servername}/memberlink/assets/products/${widget.myproduct.productFilename}",
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            "assets/images/na.png", // Fallback image
                            height: screenHeight / 4,
                          ),
                          height: screenHeight / 4,
                          width: screenWidth / 1,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Product Details
                    Text(
                      "${widget.myproduct.productName}",
                      style: GoogleFonts.montserrat(fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 127, 0, 200)), 
                    ),
                    Text(
                      "${widget.myproduct.productDescription}",
                        style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Color.fromARGB(255, 127, 0, 200),), 
                        textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "RM ${widget.myproduct.productPrice}",
                        style: GoogleFonts.montserrat(fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 127, 0, 200)),
                      ),
                    ),
                    Text(
                      "Quantity: ${widget.myproduct.productQuantity}",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Color.fromARGB(255, 127, 0, 200)), 
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Quantity decrement button
                        IconButton(
                          onPressed: () {
                            setState(() {
                              int currentQuantity =
                                  int.tryParse(quantityController.text) ?? 1;
                              if (currentQuantity > 1) {
                                quantityController.text =
                                    (currentQuantity - 1).toString();
                              }
                            });
                          },
                          icon: const Icon(Icons.remove),
                          iconSize: 20,
                        ),
                        const SizedBox(width: 3),
                        // Quantity input field with validator
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: TextFormField(
                            controller: quantityController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(2),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter quantity";
                              }
                              if (int.tryParse(value) == null || int.parse(value) <= 0) {
                                return "Enter a valid number";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              //quantityController.text = "1";
                              setState(() {
                                int? newQuantity = int.tryParse(value);
                                if (newQuantity == null || newQuantity <= 0) {
                                   quantityController.text = "1";
                                  
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 3),
                        // Quantity increment button
                        IconButton(
                          onPressed: () {
                            setState(() {
                              int currentQuantity =
                                  int.tryParse(quantityController.text) ?? 1;
                              quantityController.text =
                                  (currentQuantity + 1).toString();
                            });
                          },
                          icon: const Icon(Icons.add),
                          iconSize: 20,
                        ),
                        const SizedBox(width: 3),
                        // Add to Cart button
                        MaterialButton(
                          onPressed: () {
                            insertCartDialog();
                          },
                          color: Color.fromARGB(255, 127, 0, 200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          height: 50,
                          minWidth: 150,
                          child: Text(
                            "Add to Cart",
                                style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold), 
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }
  
  void insertCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Insert to cart",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                await insertCart();
                Navigator.push(context, MaterialPageRoute(builder: (content) => ProductScreen())); // Go back to the previous screen
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> insertCart() async {
    final url =
        Uri.parse("${MyConfig.servername}/memberlink/api/insert_cart.php");
    final quantity = int.tryParse(quantityController.text) ?? 1;
    final body = {
      "product_id": widget.myproduct.productId.toString(),
      "quantity": quantity.toString(),
    };

    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added to Cart!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to Add to Cart."),
            backgroundColor: Colors.green),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error: Unable to Add to Cart."),
          backgroundColor: Colors.red),
      );
    }
  }

}
