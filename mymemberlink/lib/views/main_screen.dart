import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:mymemberlink/models/bulletin.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlink/views/new_bulletin.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  List<Bulletin> bulletinList = [];

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      loadBulletinData();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: bulletinList.isEmpty
      ? const Center(
        child: Text("no data"),
      ):ListView.builder(
        itemCount: bulletinList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child:ListTile(
              title: Text(bulletinList[index].bulletinTitle.toString()),
              subtitle: Text(bulletinList[index].bulletinDetails.toString()),
              
            ),
          ) ;
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
            decoration: BoxDecoration(
            color: Colors.purple ,
            ),
            child: Text("Drawer Header"),
            ),
            ListTile( title: Text("News Letter"),
            ),
            ListTile( title: Text("Events"),
            ),
            ListTile( title: Text("Members"),
            ),
            ListTile( title: Text("Vetting"),
            ),
            ListTile( title: Text("Payments"),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //loadBulletinData();
          await Navigator.push(//wait for this to happen
          context,
          MaterialPageRoute(
          builder: (content) => const NewBulletinScreen()));
          loadBulletinData();// load back the data
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  void loadBulletinData() {
    http.
        get(Uri.parse("${MyConfig.servername}/memberlink/api/load_bulletin.php"))
        .then((response) {
          //print(response);
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['status']== "success") {
              var result = data['data']['bulletin'];
              
              bulletinList.clear();

              for(var item in result){
                Bulletin bulletin = Bulletin.fromJson(item);
                bulletinList.add(bulletin);
                print(bulletin.bulletinTitle);
              }
              setState(() {
                
              });
            }
          }else{
            print("error");
          }
    });
  }
}