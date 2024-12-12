import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mymemberlink/models/myproduct.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:mymemberlink/views/cart/cart_screen.dart';
import 'package:mymemberlink/views/products/new_product.dart';
import 'package:mymemberlink/views/products/product_detail.dart';
import 'package:mymemberlink/views/shared/drawer_main_screen.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<MyProduct> productList = [];
  int numofpage = 1;
  int currentpage = 1;
  int numofresult = 0;
  late double screenWidth, screenHeight;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  String status = "Loading..";
  var color;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProductData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final appBarHeight = isPortrait ? 145.0 : 90.0; // Set height 
    final childAspectRatio = isPortrait ? 0.75 : 1.2;

    if (screenWidth <= 600){
      
    }

    return Scaffold(
      drawer: MainScreenDrawer(),
      appBar: AppBar(
        title: Text(
          "Products",
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              loadProductData();
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
        toolbarHeight: appBarHeight,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
            child: Container(
              height: 30,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        "Page: $currentpage/Result: $numofresult",
                        style: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (content) => CartScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.deepPurple,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
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
              child: productList.isEmpty
                  ? Center(
                      child: Text(
                        "No Data..",
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                    )
                  : GridView.count(
                      childAspectRatio: childAspectRatio,
                      crossAxisCount: 2,
                      children: List.generate(productList.length, (index) {
                        return Card(
                          child: InkWell(
                            splashColor: Colors.deepPurple,
                            onLongPress: () {
                              deleteDialog(index);
                            },
                            onTap: () async {
                              Navigator.pop(context);
                              MyProduct myProduct = productList[index];
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (content) =>
                                      ProductDetailScreen(myproduct: myProduct),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
                              child: Column(
                                children: [
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15), // Set the desired radius for the curve
                                        child: Image.network(
                                          errorBuilder: (context, error, stackTrace) => SizedBox(
                                            height: screenHeight / 6,
                                            child: Image.asset(
                                              "assets/images/na.png",
                                            ),
                                          ),
                                          width: screenWidth / 2,
                                          height: screenHeight / 6,
                                          fit: BoxFit.cover,
                                          scale: 4,
                                          "${MyConfig.servername}/memberlink/assets/products/${productList[index].productFilename}",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        truncateString(productList[index].productName.toString(), 15),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 127, 0, 200),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        truncateString(productList[index].productDescription.toString(), 25),
                                        maxLines: 1,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Color.fromARGB(255, 127, 0, 200),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(8, 18, 0, 0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "RM ${productList[index].productPrice.toString()}",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(255, 127, 0, 200),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "Qty: ${productList[index].productQuantity.toString()}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
            ),
          ),
          Container(
            color:Color.fromARGB(255, 80, 17, 148),
            width: double.infinity,  // Ensure the container spans the entire width
            height: screenHeight * 0.05,
            child: Align(
              alignment: Alignment.center,
              child: ListView.builder(
              shrinkWrap: true,
              itemCount: numofpage,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                color = (currentpage - 1) == index ? Colors.yellow[500] : Colors.white;
                return TextButton(
                  onPressed: () {
                    setState(() {
                      currentpage = index + 1;
                      loadProductData();
                    });
                  },
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(color: color, fontSize: 18),
                  ),
                );
              },
            ),

            ) 
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 178, 78, 255),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (content) => const NewProductScreen()),
          );
          loadProductData();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );

                }
    
      void loadProductData() {
        http
          .get(Uri.parse("${MyConfig.servername}/memberlink/api/load_product.php?pageno=$currentpage"))
          .then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            var result = data['data']['products'];

            productList.clear();

            for (var item in result) {
              MyProduct myProduct = MyProduct.fromJson(item);
              productList.add(myProduct);
            }
            numofpage = int.parse(data['numofpage'].toString());
            numofresult = int.parse(data['numberofresult'].toString());
            
            setState(() {});
          } else {
            status = "No Data";
          }
        } else {
          status = "Error loading data";
          print("Error");
          setState(() {});
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

    void deleteDialog(int index) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(
                "Delete \"${truncateString(productList[index].productName.toString(), 20)}\"",
                style: const TextStyle(fontSize: 18),
              ),
              content:
                  const Text("Are you sure you want to delete this product?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    deleteProduct(index);
                    Navigator.pop(context);
                  },
                  child: const Text("Yes"),
                )
              ]);
            });
          }    
        
    
      void deleteProduct(int index) {
        http.post(
          Uri.parse("${MyConfig.servername}/memberlink/api/delete_product.php"),
          body: {
            "productid": productList[index].productId.toString()
          }).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          // log(data.toString());
          if (data['status'] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Success Delete"),
              backgroundColor: Colors.green,
            ));
            loadProductData(); //reload data
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Failed Delete"),
              backgroundColor: Colors.red,
            ));
          }
        }
      }); 
    }
    
    String capitalizeEachWord(String input) {
    if (input.isEmpty) return input;

    return input
        .split(' ') // Split the string into words
        .map((word) =>
            word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '')
        .join(' '); // Join the words back into a single string
    }

  }

