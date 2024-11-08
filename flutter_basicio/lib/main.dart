import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MyAppState();
}


class _MyAppState extends State<MainApp> {
  TextEditingController num1textEditingController = TextEditingController();
  TextEditingController num2textEditingController = TextEditingController();
  int result = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Basic IO",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Basic IO",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          elevation: 10,
        ),
        body: Center(
          child: Card(
            elevation: 15,
            shadowColor: Colors.deepPurple.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Simple Calculator",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: num1textEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter First Number",
                      labelStyle: TextStyle(color: Colors.deepPurple[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.deepPurple,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: num2textEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter Second Number",
                      labelStyle: TextStyle(color: Colors.deepPurple[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.deepPurple,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    height: 10,
                    color: Colors.deepPurpleAccent,
                    thickness: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: calculateMe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.deepPurple, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.calculate, size: 18),
                        label: const Text("Calculate"),
                      ),
                      OutlinedButton.icon(
                        onPressed: clearScreen,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepPurple,
                          side: const BorderSide(color: Colors.deepPurple, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.clear, size: 18),
                        label: const Text("Clear"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Result: $result",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
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

  void calculateMe() {
    int num1 = int.parse(num1textEditingController.text);
    int num2 = int.parse(num2textEditingController.text);
    result = num1 + num2;
    setState(() {});
  }

  void clearScreen() {
    num1textEditingController.clear();
    num2textEditingController.clear();
    setState(() {});
  }
}
