import 'package:flutter/material.dart';

//main or entry point
void main() {
  runApp(const MyApp()); //it run another class call MyApp()
}


//s>flutter create --or comm.uum myapp
class MyApp extends StatelessWidget { //class that extends with another class
  const MyApp({super.key}); //constructor

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) { //this is UI part

    return MaterialApp( //Android UI
      title: 'My App',
      theme: ThemeData.light(),
      home: const MyHomePage(title: 'My App'),
    );
  }
}

//stateful
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
       
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text("hello app"), 
        backgroundColor: const Color.fromARGB(255, 106, 7, 255), 
        centerTitle: true,
      ),
      body: Center(
        
        child: Column(
          children: [
            Text("welcome to flutter."),
            Text("welcome to flutter."),
            Text("welcome to flutter."),
            MaterialButton(onPressed: (){}, child: Text("Click Me"),)
          ],
        ),
      ),
      
    );
  }
}
