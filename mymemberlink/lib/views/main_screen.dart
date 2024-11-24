import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymemberlink/models/bulletin.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlink/views/drawer_main_screen.dart';
import 'package:mymemberlink/views/edit_bulletin.dart';
import 'package:mymemberlink/views/new_bulletin.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  List<Bulletin> bulletinList = [];
  final df = DateFormat('dd/MM/yyyy hh:mm a');

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
              onLongPress: (){
                deleteDialog(index);
              },

              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    truncateString(bulletinList[index].bulletinTitle.toString(), 30),
                    style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    df.format(DateTime.parse(bulletinList[index].bulletinDate.toString())),
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
              subtitle: Text(truncateString(
                  bulletinList[index].bulletinDetails.toString(), 150),
                  textAlign: TextAlign.justify,
              ),
              
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: (){
                  showBulletinDialog(index);
                },
                ),
            ),
          );
        },
      ),

      drawer: const MainScreenDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          
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
              }
              setState(() {
                
              });
            }
          }else{
            print("error");
          }
    });
  }
  
  void deleteDialog(int index) {
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Delete \"${truncateString(bulletinList[index].bulletinTitle.toString(), 20)}\"",
          style: const TextStyle(
            fontSize: 18
          ),
        ),
        content: const Text("Are you sure to delete this bulletin?"),
        actions: [
          TextButton(
            onPressed: (){
              deleteBulletin(index);
              Navigator.pop(context);
            },
            child: const Text("Yes")),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text("No"))
        ],
        );
        
      });
  }
  
   void deleteBulletin(int index) {
    http.post(
      Uri.parse("${MyConfig.servername}/memberlink/api/delete_bulletin.php"),
      body: {"bulletinid": bulletinList[index].bulletinId.toString()}).then((response){
        if (response.statusCode == 200){
          var data = jsonDecode(response.body);
          //log(data.toString());
          if(data['status'] == "success"){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Succes"),
              backgroundColor: Colors.green));
            loadBulletinData();
          }else{
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Failed"),
              backgroundColor: Colors.red));
          }
        }
      });
  }
  
  String truncateString(String str, int length) {
    if(str.length>length){
      str = str.substring(0,length);
      return "$str...";
    }else{
      return str;
    }
  }
  
  void showBulletinDialog(int index) {
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text(bulletinList[index].bulletinTitle.toString()),
          content: Text(bulletinList[index].bulletinDetails.toString(),
          textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
                Bulletin bulletin = bulletinList[index];

                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (content) => EditBulletinScreen(bulletin: bulletin)));
              }, 
              child: const Text("Edit")
              ),
              TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("Close"))
          ],
        );
      });
  }
  

  
}