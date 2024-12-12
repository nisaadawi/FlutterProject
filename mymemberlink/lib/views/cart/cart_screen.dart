import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mymemberlink/models/cart.dart';
import 'package:mymemberlink/myconfig.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartItems = [];
  double totalPrice = 0.0;
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadCartData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: GoogleFonts.lexendTera(
            color: const Color.fromARGB(252, 255, 255, 255),
            fontSize: 40,
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
              image: AssetImage('assets/bg/cart.png'),
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
        child: cartItems.isEmpty
            ? const Center(child: Text("No items in the cart."))
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                child: ListView.builder(
                                  itemCount: cartItems.length,
                                  itemBuilder: (context, index) {
                                    final cartItem = cartItems[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: SizedBox(
                                          width: 80,
                                          height: 120,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.1),
                                                    blurRadius: 8,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: Image.network(
                                                "${MyConfig.servername}/memberlink/assets/products/${cartItem.productFileName}",
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    Container(
                                                      color: Colors.grey.shade200,
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        size: 50,
                                                        color: Colors.grey.shade600,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          cartItem.productName,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 127, 0, 200),
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Qty: ${cartItem.quantity}",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            color: Color.fromARGB(255, 127, 0, 200),
                                          ),
                                        ),
                                        trailing: Text(
                                          "RM ${cartItem.price.toStringAsFixed(2)}",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 127, 0, 200),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "Total Price: RM ${totalPrice.toStringAsFixed(2)}",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 127, 0, 200),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: (){},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 127, 0, 200), // Text color
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                    ),
                                    child: Text("Check Out",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> loadCartData() async {
    final url = Uri.parse("${MyConfig.servername}/memberlink/api/load_cart.php");

    try {
      final response = await http.get(url);

      // Log the raw response
      debugPrint("[log] Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          var items = data['data']['cart'];
          cartItems = items.map<Cart>((item) => Cart.fromJson(item)).toList();

          // Sum up the total price directly
          totalPrice = cartItems.fold(0.0, (sum, item) => sum + item.price);

          setState(() {}); // Update the UI with the fetched data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Failed to load cart")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Unable to load cart")),
        );
      }
    } catch (error) {
      debugPrint("[log] Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }
}
