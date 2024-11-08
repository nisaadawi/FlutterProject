import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'person.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PersonScreen(),

    );
  }
}

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreen();
}

class _PersonScreen extends State<PersonScreen> {

 List<Person> personList =[]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Person List"),
        backgroundColor: Colors.amber,
      ),
      body: personList.isEmpty
        ? const Center(child: Text("NO DATA"),
        )
        : GridView.count(crossAxisCount: 2, children: List.generate(personList.length, (index){
          return Card(
            color: const Color.fromARGB(255, 243, 233, 151),
            elevation: 10.0,
            child: Padding(padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(personList[index].name.toString(),
                  style: const TextStyle(
                  fontWeight:FontWeight.bold,
                  fontSize: 16,
                  ),
                ),
                Text(personList[index].email.toString()),
                Text(personList[index].country.toString()),
                Text(personList[index].address.toString()),
              ],
            ),
            ),
          );
        }),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: onPressed, 
        child : const Icon(Icons.download),
        ),
    );
  }

  void onPressed() async{
  int c = 20;
    http.
        get(
      Uri.parse("https://slumberjer.com/myfaker/myfaker.php?count=$c"),
    )
        .then((response){
       if (response.statusCode == 200){
        var resp = convert.jsonDecode(response.body);
        if(resp['status']== "success"){
          personList.clear();
          resp['data'].forEach((v) {
            personList.add(Person.fromJson(v));
            print(v.toString());
          
          });
          setState(() {
            
          });
        }
       }
    });
      }

  }




 

